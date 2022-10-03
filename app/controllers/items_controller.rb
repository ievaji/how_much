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
    authorize @item
    @item.save!
    @item.update_parent
    redirect_to list_path(@list)
  end

  def destroy
    authorize @item
    @list = current_user.lists.find(@item.list.id)
    @item.destroy
    @list.reset_value
    @list.update_parents
    redirect_to list_path(@list)
  end

  private

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
