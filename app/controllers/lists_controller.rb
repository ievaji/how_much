class ListsController < ApplicationController
  def show
    @list = List.find(list_id)
  end

  private

  def list_id
    params[:id]
  end
end
