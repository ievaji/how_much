class ListPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    record.user_id == user.id
  end

  def new?
    record.user_id == user.id
  end

  def create?
    true
  end

  def lists?
    if record.is_a?(ActiveRecord::AssociationRelation)
      record.each { |r| true if r.user_id == user.id }
    else
      record.user_id == user.id
    end
  end

  def update?
    if record.is_a?(ActiveRecord::AssociationRelation)
      record.each { |r| true if r.user_id == user.id }
    else
      record.user_id == user.id
    end
  end

  # def add_tracker
  #   record.user_id == user.id
  # end

  def destroy?
    record.user_id == user.id
  end
end
