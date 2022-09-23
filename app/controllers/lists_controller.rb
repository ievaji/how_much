class ListsController < ApplicationController
  before_action :set_lists

  def show
    @list = List.find(list_id)
    authorize @list
  end

  def new
    @window = Window.find(window_id)
    @list = current_user.lists.build
    authorize @list
  end

  def create
    if li_ids.present? # dirty and confused move. but TBR later - works for now
      add_tracker
    else
      @list ||= List.new(name: list_name, budget: budget,
                         window_id: window_id, user_id: current_user.id)
      @list.save!
      authorize @list
      redirect_to window_path(window_id)
    end
  end

  def index
    @lists = policy_scope(List)
    @window = Window.find(window_id)
  end

  def update
    @list = List.find(list_id)
    @lists = @lists.where.not(id: @list.id)
    authorize @list

    # definitely not a clean solution. TBR - same as in Windows.
    # maybe need a SuperClass, if the methods are actually the same.
    # there's an idea for refactoring!
    if request.patch?
      return unless input_provided?

      track_request? ? track_selected : untrack_list
    end

    redirect_to list_path(@list)
  end

  def add_tracker
    authorize @lists
    li_ids.each { |id| List.find(id).tracker_windows << Window.find(window_id) }
    redirect_to window_path(window_id)
  end

  def destroy
    @list = List.find(list_id)
    authorize @list
    window = @list.window.id
    @list.destroy
    redirect_to window_path(window)
  end

  private

  def set_lists
    @lists = List.where(user_id: current_user.id)
  end

  def list_id
    params[:id]
  end

  def input_provided?
    !li_ids.nil? || !li_id.nil?
  end

  def track_request?
    !li_ids.nil?
  end

  def track_selected
    li_ids.each { |id| @list.tracked_lists << List.find(id) }
  end

  def untrack_list
    li = List.find(li_id)
    @list.tracked_lists.delete(li)
  end

  def li_ids
    params[:li_ids]
  end

  def li_id
    params[:li_id]
  end

  def window_id
    params[:window_id]
  end

  def list_name
    params[:list][:name]
  end

  def budget
    params[:list][:budget]
  end
end
