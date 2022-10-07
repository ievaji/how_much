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
    [window, tracker_lists.to_a, tracker_windows.to_a].flatten
  end

  def children
    [items.to_a, tracked_lists.to_a].flatten
  end

  def family
    [parents, children].flatten
  end

  def reset_value
    self.value = 0
    children.each { |child| self.value += child.value }
    self.save!
    self
  end

  def update_parents
    parents.each do |parent|
      parent.reset_value
      parent.update_parents unless parent.parents.empty?
    end
  end

  # ! might also need refactoring
  def related_to?(other)
    other_fam = other.family
    return true if other_fam.include?(self)

    this_fam = self.family
    return true if this_fam.include?(other)

    both = [this_fam, other_fam].flatten
    return true if both.length != both.uniq.length

    return false
  end

  def unrelated(collection)
    collection = collection.to_a
    related = []
    collection.each { |instance| related << check(instance) unless check(instance).nil? }
    related.each { |instance| collection.delete(instance) } unless related.empty?
    collection
  end

  def check(instance)
    instance.family.each do |member|
      return instance if member.related_to?(self)

      member.family { |m| return instance if m.related_to?(self) }
    end
  end
end
