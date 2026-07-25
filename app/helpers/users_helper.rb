module UsersHelper
  def user_role_options
    User::ROLES.map { |role| [ t("users.roles.#{role}"), role ] }
  end
end
