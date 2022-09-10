class Window < ApplicationRecord
  belongs_to :user
  belongs_to :tracker, class_name: 'Window', optional: true

  has_many :lists, dependent: :destroy
  has_many :items, through: :lists

  has_many :tracked_lists, foreign_key: 'tracker_id', class_name: 'Window'
  has_many :tracked_windows, foreign_key: 'tracker_id', class_name: 'Window'

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than: :start_date }
end
