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
    [lists.to_a, tracked_lists.to_a, tracked_windows.to_a].flatten
  end

  def family
    [parents, children].flatten
  end

  def reset_value
    self.value = 0
    children.each { |child| self.value += child.value }
    self.save!
    return self
  end

  def update_parents
    parents.each do |parent|
      parent.reset_value
      parent.update_parents unless parent.parents.empty?
    end
  end

  def unrelated(collection)
    collection = collection.to_a
    related = []
    collection.each { |instance| related << check(instance) unless check(instance).nil? }
    related.each { |instance| collection.delete(instance) } unless related.empty?
    collection
  end

  private

  def check(instance)
    instance.family.each do |member|
      return instance if member.related_to?(self)

      member.family { |m| return instance if m.related_to?(self) }
    end
  end

  def related_to?(other)
    other_fam = other.family
    return true if other_fam.include?(self)

    this_fam = self.family
    return true if this_fam.include?(other)

    both = [this_fam, other_fam].flatten
    return true if both.length != both.uniq.length

    return false
  end
end
