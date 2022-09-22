class ListsController < ApplicationController
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
    @list ||= List.new(name: list_name,
                       budget: budget,
                       window_id: window_id,
                       user_id: current_user.id)
    @list.save!
    authorize @list
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

  def list_id
    params[:id]
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
