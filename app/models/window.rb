class Window < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy

  has_and_belongs_to_many :tracked_windows,
                          class_name: 'Window',
                          foreign_key: 'tracker_id',
                          association_foreign_key: 'tracked_window_id',
                          optional: true
  # Adding tracked_windows works like this:
  #
  # Window.find(2).tracked_windows << Window.find(3)
  #
  # Point: it's an []. So, need to use <<
  #
  # !!! Can also user arr.methods like .empty?
  has_and_belongs_to_many :tracked_lists,
                          class_name: 'List',
                          association_foreign_key: 'tracked_list_id',
                          optional: true

  validates :name, presence: true
  validates :budget, numericality: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
