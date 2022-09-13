class WindowsController < ApplicationController
  def index
    @windows = Window.where(user_id: current_user).order('start_date DESC')
  end

  def show
    @window = Window.find(window_id)
  end

  private

  def window_id
    params[:id]
  end
end
