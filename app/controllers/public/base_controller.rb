module Public
  # Společný základ stránek bez přihlášení. Firmu bere z adresy, ne z uživatele.
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :set_current_account

    before_action :set_account_from_slug

    layout "public"

    private

    def set_account_from_slug
      Current.account = Account.find_by!(slug: params[:account_slug])
    end
  end
end
