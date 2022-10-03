class List < ApplicationRecord
  belongs_to :user
  belongs_to :window

  has_many :items, dependent: :destroy

  has_and_belongs_to_many :tracker_windows,
                          class_name: 'Window',
                          join_table: :windows_lists,
                          association_foreign_key: 'tracker_id',
                          foreign_key: 'tracked_list_id',
                          optional: true

  has_and_belongs_to_many :tracker_lists,
                          class_name: 'List',
                          association_foreign_key: 'tracker_id',
                          foreign_key: 'tracked_list_id',
                          optional: true

  has_and_belongs_to_many :tracked_lists,
                          class_name: 'List',
                          foreign_key: 'tracker_id',
                          association_foreign_key: 'tracked_list_id',
                          optional: true

  validates :name, presence: true
  validates :budget, numericality: true

  def parents
    parents = [tracker_lists, tracker_windows]
    result = [window]
    parents.each do |parent|
      parent.each { |e| result << e } unless parent.empty?
    end
    result
  end

  def children
    children = [items, tracked_lists]
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
end
