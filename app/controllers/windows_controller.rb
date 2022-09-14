class WindowsController < ApplicationController
  before_action :set_windows

  def open
    @open = @windows.where(closed: false)
    authorize @open
  end

  def closed
    @closed = @windows.where(closed: true)
    authorize @closed
  end

  def show
    @window = Window.find(window_id)
    authorize @window
  end

  private

  def set_windows
    @windows = Window.where(user_id: current_user)
  end

  def window_id
    params[:id]
  end
end
