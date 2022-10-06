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
    [tracker_lists.to_a, tracker_windows.to_a].flatten
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
  end

  def update_parents
    parents.each do |parent|
      parent.reset_value
      parent.update_parents unless parent.parents.empty?
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

  def unrelated(collection)
    result = []
    collection.each { |instance| result << instance unless instance.related_to?(self) }
    filter(result)
  end

  # TBR :: However, it works!
  def filter(collection)
    tbd = []
    collection.each do |instance|
      element = instance.window
      tbd << instance if element.related_to?(self)
      next if tbd.include?(instance)

      element.family.each do |member|
        tbd << instance if member.related_to?(self)
        unless tbd.include?(instance)
          member.family.each do |m|
            tbd << instance if m.related_to?(self)
            break if tbd.include?(instance)
          end
        end
        break if tbd.include?(instance)
      end
    end
    tbd.each { |e| collection.delete(e) }
    collection
  end
end
