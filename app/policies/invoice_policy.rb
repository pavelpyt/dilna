# Peníze vidí a vystavuje jen majitel.
class InvoicePolicy < ApplicationPolicy
  def index? = owner?
  def create? = owner?
end
