# app/policies/event_policy.rb
class EventPolicy < ApplicationPolicy
  def index?
    true  # Everyone can view the events list
  end

  def show?
    true  # Everyone can view individual events
  end

  def create?
    user.present? && user.role == 'club_head'
  end

  def new?
    create?
  end

  def update?
    user.present? && user.role == 'club_head' && record.club.student_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end