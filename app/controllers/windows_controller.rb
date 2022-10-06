class WindowsController < ApplicationController
  before_action :set_windows
  before_action :set_lists
  before_action :find_window, except: %i[new create open closed]

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
    @collection = @window.unrelated(@lists)
  end

  def windows
    @windows = @windows.where.not(id: @window.id)
    authorize @windows
    @collection = @window.unrelated(@windows)
  end

  def update
    authorize @window
    track_request? ? track(selected) : untrack(selected)
    @window.reset_value
    @window.update_parents
    redirect_to window_path
  end

  def destroy
    authorize @window
    @window.update_family
    @window.destroy
    redirect_to open_windows_path
  end

  private

  # UPDATE
  def track_request?
    selected.values.first.is_a?(Array)
  end

  def track(selection)
    # key = :windows || :lists <- from #selected
    key = selection.keys.first
    tracked = "tracked_#{key}"
    collection = instance_variable_get("@#{key}")
    selection[key].each do |id|
      # working version:
      @window.send(tracked) << collection.find(id)
      # IN GENERAL: potential dupes should be eliminated earlier, wrong place for it
      # element = collection.find(id)
      # currently the checking breaks everything
      # @window.send(tracked) << element unless @window.related_to?(element)
    end
  end

  def untrack(selection)
    # key = :windows || :lists <- from #selected
    key = selection.keys.first
    tracked = "tracked_#{key}"
    collection = instance_variable_get("@#{key}")
    element = collection.find(selection[key])
    @window.send(tracked).delete(element)
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
    { name: data[:name], budget: data[:budget],
      start_date: start_date, end_date: end_date,
      size: end_date - start_date }
  end

  def window_id
    params.require(:id)
  end

  def selected
    options = %i[windows lists]
    result = {}
    options.each { |o| result[o] = params.require(o) unless params[o].nil? }
    result
  end
end
