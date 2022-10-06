class ListsController < ApplicationController
  before_action :set_lists
  before_action :find_list, except: %i[new create]
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
    @collection = @list.unrelated(@lists)
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

  # UPDATE
  def track_request?
    selected.is_a?(Array)
  end

  # both of these can go into MODEL
  def track(selection)
    selection.each do |id|
      element = @lists.find(id)
      @list.tracked_lists << element unless @list.related_to?(element)
    end
  end

  def untrack(selection)
    li = @lists.find(selection)
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
    params.require(:lists)
  end
end
