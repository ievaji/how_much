class ItemsController < ApplicationController
  before_action :set_list, except: :destroy
  before_action :set_window, only: :create
  before_action :set_item, only: :destroy

  def new
    @item = current_user.items.build
    authorize @item
  end

  def create
    @item = current_user.items.build(item_params)
    # @item.list_id = list_id <-- Alternative to custom hashing item_params
    recalculate_values
    @item.save!
    authorize @item
    redirect_to list_path(@list)
  end

  def destroy
    authorize @item
    @list = current_user.lists.find(@item.list.id)
    @window = @list.window
    recalculate_values
    @item.destroy
    redirect_to list_path(@list)
  end

  private

  # CREATE
  def recalculate_values
    action = caller_locations.first.base_label
    parents = [@list, @window]
    parents.each do |pt|
      action == "destroy" ? pt.current_value -= @item.value : pt.current_value += @item.value
      pt.difference = pt.budget - pt.current_value
      pt.difference.negative? ? pt.exceeded = true : pt.exceeded = false
      pt.save!
    end
  end

  # BEFORE_ACTION
  def set_list
    @list = current_user.lists.find(list_id)
  end

  def set_window
    @window = @list.window
  end

  def set_item
    @item = current_user.items.find(item_id)
  end

  # PARAMS
  def item_id
    params.require(:id)
  end

  def list_id
    params.require(:list_id)
  end

  def item_params
    data = params.require(:item).permit(:name, :value)
    { name: data[:name], value: data[:value], list_id: list_id }
  end
end
