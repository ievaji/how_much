class ListPolicy < ApplicationPolicy
  # class Scope < Scope
  #   # NOTE: Be explicit about which records you allow access to!
  #   def resolve
  #     scope.all
  #   end
  # end

  def show?
    record.user_id == user.id
  end
end
