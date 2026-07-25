# Ceník je obchodní informace — technik ji nepotřebuje měnit.
class ServicePolicy < ApplicationPolicy
  def index? = owner?
  def create? = owner?
  def update? = owner?
  def destroy? = owner?
end
