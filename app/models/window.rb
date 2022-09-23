class Window < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy

  has_and_belongs_to_many :trackers,
                          class_name: 'Window',
                          association_foreign_key: 'tracker_id',
                          foreign_key: 'tracked_window_id',
                          optional: true

  has_and_belongs_to_many :tracked_windows,
                          class_name: 'Window',
                          foreign_key: 'tracker_id',
                          association_foreign_key: 'tracked_window_id',
                          optional: true

  has_and_belongs_to_many :tracked_lists,
                          class_name: 'List',
                          join_table: :windows_lists,
                          foreign_key: 'tracker_id',
                          association_foreign_key: 'tracked_list_id',
                          optional: true

  validates :name, presence: true
  validates :budget, numericality: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
