module Public
  # Společný základ stránek bez přihlášení. Firmu si každá stránka určí sama —
  # poptávkový formulář ze slugu v adrese, client hub z tokenu.
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :set_current_account

    layout "public"
  end
end
