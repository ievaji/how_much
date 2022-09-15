class List < ApplicationRecord
  belongs_to :user
  belongs_to :window

  has_many :items, dependent: :destroy

  has_and_belongs_to_many :trackers,
                          class_name: 'Window',
                          join_table: :windows_lists,
                          association_foreign_key: 'tracker_id',
                          foreign_key: 'tracked_list_id',
                          optional: true

  validates :name, presence: true
  validates :budget, numericality: true
end
