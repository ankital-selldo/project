# app/policies/club_policy.rb
class ClubPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role == "admin"
        scope.all
      elsif user.role == "club_head"
        # Club head can only see clubs they manage
        scope.where(student_id: user.id)
      else
        scope.all # Regular users can see all clubs but not edit them
      end
    end
  end

  def index?
    true # Anyone can view the list of clubs
  end

  def show?
    true # Anyone can view club details
  end

  def create?
    user.role == "admin" # Only admins can create new clubs
  end

  def update?
    return true if user.role == "admin"
    return true if user.role == "club_head" && record.student_id == user.id
    false
  end

  def destroy?
    return true if user.role == "admin"
    return true if user.role == "club_head" && record.student_id == user.id
    false
  end

  def my_club?
    user.role == "club_head"
  end
end