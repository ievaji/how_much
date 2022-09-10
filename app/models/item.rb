class Item < ApplicationRecord
  belongs_to :user
  belongs_to :list

  validates :value, presence: true, numericality: true
end
