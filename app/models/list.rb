class List < ApplicationRecord
  belongs_to :user
  belongs_to :window
  belongs_to :tracker, class_name: 'Window', optional: true

  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :budget, numericality: true
end
