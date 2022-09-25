class WindowsController < ApplicationController
  before_action :set_windows
  before_action :set_lists
  before_action :find_window, only: %i[show lists windows update destroy]

  def open
    @open = @windows.where(closed: false)
    authorize @open
  end

  def closed
    @closed = @windows.where(closed: true)
    authorize @closed
  end

  def show
    authorize @window
  end

  def new
    @window = current_user.windows.build
    authorize @window
  end

  def create
    @window = current_user.windows.build(window_params)
    @window.save!
    authorize @window
    redirect_to open_windows_path
  end

  def lists
    @lists = @lists.where.not(window_id: @window.id)
    authorize @lists
  end

  def windows
    @windows = @windows.where.not(id: @window.id)
    authorize @windows
  end

  def update
    # would be better to authorize the selected windows/lists
    # but need some changes for that: get the selected windows/lists first
    authorize @window

    track_request? ? track(selected) : untrack(selected)

    redirect_to window_path
  end

  def destroy
    authorize @window
    @window.destroy
    redirect_to open_windows_path
  end

  private

  # UPDATE
  def track_request?
    selected.values.first.is_a?(Array)
  end

  def track(ids)
    if ids.key?(:win_id)
      ids[:win_id].each { |id| @window.tracked_windows << @windows.find(id) }
    else
      ids[:li_id].each { |id| @window.tracked_lists << @lists.find(id) }
    end
  end

  def untrack(ids)
    if ids.key?(:win_id)
      win = @windows.find(ids[:win_id])
      @window.tracked_windows.delete(win)
    else
      li = @lists.find(ids[:li_id])
      @window.tracked_lists.delete(li)
    end
  end

  def selected
    options = %i[win_id li_id]
    result = {}
    options.each { |op| result[op] = params.require(op) unless params[op].nil? }
    result
  end

  # BEFORE_ACTION
  def set_windows
    @windows = current_user.windows.order(start_date: :desc)
  end

  def set_lists
    @lists = current_user.lists.order(window_id: :desc)
  end

  def find_window
    @window = @windows.find(window_id)
  end

  # PARAMS
  def window_params
    dates = []
    data = params.require(:window).permit!
    data.each { |k, v| dates << v.to_i if k.include?("date") }
    start_date = Date.new(dates[0], dates[1], dates[2])
    end_date = Date.new(dates[3], dates[4], dates[5])
    Hash.new(name: data[:name], budget: data[:budget],
             start_date: start_date, end_date: end_date,
             size: end_date - start_date)
  end

  def window_id
    params.require(:id)
  end
end
