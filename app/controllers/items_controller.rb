class ItemsController < ApplicationController
  def new
    @list = List.find(list_id)
    @item = current_user.items.build
    authorize @item
  end

  def create
    @item ||= Item.new(name: item_name,
                       value: value,
                       list_id: list_id,
                       user_id: current_user.id)
    @item.save!
    authorize @item
    redirect_to list_path(list_id)
  end

  def destroy
    @item = Item.find(item_id)
    authorize @item
    list = @item.list.id
    @item.destroy
    redirect_to list_path(list)
  end

  private

  def item_id
    params[:id]
  end

  def list_id
    params[:list_id]
  end

  def item_name
    params[:item][:name]
  end

  def value
    params[:item][:value]
  end
end
