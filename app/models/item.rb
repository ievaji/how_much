class Item < ApplicationRecord
  belongs_to :user
  belongs_to :list

  validates :value, presence: true, numericality: true

  def parent
    list
  end

  def update_parent
    parent.reset_value
    parent.update_parents unless parent.parents.empty?
  end
end
