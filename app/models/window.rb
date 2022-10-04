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

  def parents
    trackers.to_a
  end

  def children
    children = [lists, tracked_lists, tracked_windows]
    result = []
    children.each do |child|
      child.each { |e| result << e } unless child.empty?
    end
    result
  end

  def reset_value
    self.value = 0
    children.each { |child| self.value += child.value }
    self.save!
  end

  def update_parents
    parents.each do |parent|
      parent.reset_value
      parent.update_parents unless parent.parents.empty?
    end
  end

  def update_family
    children.each do |child|
      child.value = 0
      child.save!
      child.update_parents
    end
    parents.each do |parent|
      parent.value -= self.value
      parent.save!
      parent.update_parents
    end
  end
end
