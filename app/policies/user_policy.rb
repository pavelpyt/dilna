class UserPolicy < ApplicationPolicy
  def index? = owner?
  def create? = owner?
  def update? = owner?

  # Majitel nesmí smazat sám sebe, jinak by firma zůstala bez správce.
  def destroy?
    owner? && record != user
  end
end
