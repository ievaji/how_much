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
    # alternatively i could just get the WHOLE family here already
    # but starting out with a MASSIVE dataset might not be the best idea
    # i like the gradual crawling option better, just gotta make it work
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

  def update_family
    children.each do |child|
      child.update!(value: 0)
      child.update_parents
    end
    parents.each do |parent|
      parent.value -= self.value
      parent.save!
      parent.update_parents
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

  # TBR !!! Doesn't fully work yet
  def not_related_to(collection)
    temp = []
    collection.each do |window|
      temp << window unless window.related_to?(self)
    end
    result = temp
    temp.each do |window|
      window.parents.each do |parent|
        related = false
        parent.family.each do |member|
          if member.related_to?(self)
            result.delete(window)
            related = true
            break
          end
        end
        break if related
      end
    end
    temp = result
    temp.each do |window|
      window.children.each do |child|
        related = false
        child.family.each do |member|
          if member.related_to?(self)
            result.delete(window)
            related = true
            break
          end
        end
        break if related
      end
    end
    result
  end
end
