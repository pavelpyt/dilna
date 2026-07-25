# Základ pro všechny policy. Role jsou jen dvě: majitel vidí všechno,
# technik svoji práci — ne peníze a ne správu týmu.
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index? = false
  def show? = false
  def create? = false
  def new? = create?
  def update? = false
  def edit? = update?
  def destroy? = false

  private

  def owner?
    user.owner?
  end
end
