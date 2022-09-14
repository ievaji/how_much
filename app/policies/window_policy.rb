class WindowPolicy < ApplicationPolicy
  # class Scope < Scope
  #   # NOTE: Be explicit about which records you allow access to!
  #   def resolve
  #     # scope.all
  #   end
  # end

  def open?
    # this is basically doubling the DB query in windows_controller.
    # the idea is to prevent injection, but maybe it's an overkill.
    # first would need to look up, if an injection is even possible here.
    record.each { |r| true if r.user_id == user.id }
  end

  def closed?
    record.each { |r| true if r.user_id == user.id }
  end

  def show?
    record.user_id == user.id
  end
end
