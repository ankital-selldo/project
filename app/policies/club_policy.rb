class ClubPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role == "admin"
        scope.all
      elsif user.role == "club_head"
        scope.where(student_id: user.id)
      else
        scope.all 
      end
    end
  end

  def index?
    true
  end

  def show?
    true 
  end

  def create?
    user.role == "admin" || user.role == "club_head"
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