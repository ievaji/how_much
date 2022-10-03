class ListsController < ApplicationController
  before_action :set_lists
  before_action :find_list, only: %i[show lists update destroy]
  before_action :find_window, only: %i[new create]

  def show
    authorize @list
  end

  def new
    @list = current_user.lists.build
    authorize @list
  end

  def create
    @list = current_user.lists.build(list_params)
    @list.save!
    authorize @list
    redirect_to window_path(@window)
  end

  def lists
    @lists = @lists.where.not(window_id: @list.window_id)
    authorize @lists
  end

  def update
    authorize @list
    track_request? ? track(selected) : untrack(selected)
    @list.reset_value
    @list.update_parents
    redirect_to list_path(@list)
  end

  def destroy
    authorize @list
    @window = current_user.windows.find(@list.window.id)
    parents = @list.parents
    @list.destroy
    parents.each do |parent|
      parent.reset_value
      parent.update_parents
    end
    redirect_to window_path(@window)
  end

  private

  #UPDATE
  def track_request?
    selected.is_a?(Array)
  end

  def track(ids)
    ids.each { |id| @list.tracked_lists << @lists.find(id) }
  end

  def untrack(id)
    li = @lists.find(id)
    @list.tracked_lists.delete(li)
  end

  # BEFORE_ACTION
  def set_lists
    # This ordering can go into model: used here & in WindowsController too
    @lists = current_user.lists.order(window_id: :desc)
  end

  def find_list
    @list = @lists.find(list_id)
  end

  def find_window
    @window = current_user.windows.find(params.require(:window_id))
  end

  #PARAMS
  def list_params
    data = params.require(:list).permit!
    { name: data[:name], budget: data[:budget], window_id: @window.id }
  end

  def list_id
    params.require(:id)
  end

  def selected
    params.require(:li_id)
  end
end
