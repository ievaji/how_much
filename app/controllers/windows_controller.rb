class WindowsController < ApplicationController
  before_action :set_windows
  before_action :set_lists
  before_action :find_window, only: %i[show update destroy]

  def open
    @open = @windows.where(closed: false).order(start_date: :desc)
    authorize @open
  end

  def closed
    @closed = @windows.where(closed: true).order(start_date: :desc)
    authorize @closed
  end

  def show
    authorize @window
  end

  def new
    @window = current_user.windows.build
    authorize @window
  end

  # would be good to keep the #new part shorter - use a hash as input or sth
  # strong params?
  def create
    @window ||= Window.new(name: window_name, start_date: start_date,
                           end_date: end_date, budget: budget,
                           size: size, user_id: current_user.id)
    @window.save!
    authorize @window
    redirect_to open_windows_path
  end

  def update
    @add = params[:add]

    @windows = @windows.where.not(id: @window.id)
    authorize @windows

    @lists = @lists.where.not(window_id: @window.id)
    authorize @lists

    if request.patch?
      # definitely not a clean solution this guard!
      # currently using 'patch' in link_to to route to #update
      # that part should be redone - then the guard will fall away
      return unless input_provided?

      track_request? ? track_selected : untrack
    end

    redirect_to window_path(@window)
  end

  def destroy
    authorize @window
    @window.destroy
    redirect_to open_windows_path
  end

  private

  # CREATE
  def size
    end_date - start_date
  end

  # UPDATE
  def input_provided?
    !win_ids.nil? || !win_id.nil? || !li_ids.nil? || !li_id.nil?
  end

  def track_request?
    !win_ids.nil? || !li_ids.nil?
  end

  def track_selected
    # this can surely be abstracted later
    if li_ids.nil?
      win_ids.each { |id| @window.tracked_windows << @windows.find(id) }
    else
      li_ids.each { |id| @window.tracked_lists << @lists.find(id) }
    end
  end

  def untrack
    if li_id.nil?
      win = @windows.find(win_id)
      @window.tracked_windows.delete(win)
    else
      li = @lists.find(li_id)
      @window.tracked_lists.delete(li)
    end
  end

  # BEFORE_ACTION
  def set_windows
    @windows = current_user.windows
  end

  def set_lists
    @lists = current_user.lists
  end

  def find_window
    @window = @windows.find(window_id)
  end

  # PARAMS !!! TBR !!!
  def window_id
    params[:window_id].nil? ? params[:id] : params[:window_id]
  end

  def win_ids
    params[:win_ids]
  end

  def win_id
    params[:win_id]
  end

  def li_ids
    params[:li_ids]
  end

  def li_id
    params[:li_id]
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
end
