class WindowsController < ApplicationController
  before_action :set_windows

  def open
    @open = @windows.where(closed: false).order(start_date: :desc)
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

  def index
    @window = Window.find(params[:window_id])
    @windows = policy_scope(Window).order(start_date: :desc)
  end

  def new
    @window = current_user.windows.build
    authorize @window
  end

  def create
    @window ||= Window.new(name: window_name,
                           start_date: start_date,
                           end_date: end_date,
                           budget: budget,
                           size: size,
                           user_id: current_user.id)
    @window.save!
    authorize @window
    redirect_to open_windows_path
  end

  def destroy
    @window = Window.find(window_id)
    authorize @window
    @window.destroy
    redirect_to open_windows_path
  end

  private

  def set_windows
    @windows = Window.where(user_id: current_user)
  end

  def window_id
    params[:id]
  end

  def window_name
    params[:window][:name]
  end

  def budget
    params[:window][:budget]
  end

  def start_date
    day = params[:window]["start_date(3i)"].to_i
    month = params[:window]["start_date(2i)"].to_i
    year = params[:window]["start_date(1i)"].to_i
    Date.new(year, month, day)
  end

  def end_date
    day = params[:window]["end_date(3i)"].to_i
    month = params[:window]["end_date(2i)"].to_i
    year = params[:window]["end_date(1i)"].to_i
    Date.new(year, month, day)
  end

  def size
    end_date - start_date
  end
end
