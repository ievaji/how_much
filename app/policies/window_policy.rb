class WindowPolicy < ApplicationPolicy
  # class Scope < Scope
  #   # NOTE: Be explicit about which records you allow access to!
  #   def resolve
  #     scope.where(user: user)
  #   end
  # end

  # checking user_id here doubling the DB query in windows_controller.
  # the idea is to prevent injection, but maybe it's an overkill slowing things down.
  # first would need to look up, if an injection is even possible here.
  def open?
    record.each { |r| true if r.user_id == user.id }
  end

  def closed?
    record.each { |r| true if r.user_id == user.id }
  end

  def show?
    record.user_id == user.id
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    record.user_id == user.id
  end
end
