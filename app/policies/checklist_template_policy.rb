class ChecklistTemplatePolicy < ApplicationPolicy
  def index? = owner?
  def create? = owner?
  def update? = owner?
  def destroy? = owner?
end
