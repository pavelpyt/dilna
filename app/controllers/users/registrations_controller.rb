module Users
  class RegistrationsController < Devise::RegistrationsController
    private

    # Kdo si zakládá firmu, je její vlastník. Další lidi do týmu zve až on.
    def build_resource(hash = {})
      super
      resource.role = "owner"
      resource.build_account if resource.account.nil?
    end
  end
end
