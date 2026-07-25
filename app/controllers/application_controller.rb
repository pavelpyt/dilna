class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  layout :layout_for_current_page

  before_action :authenticate_user!
  before_action :set_current_account
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_account

  rescue_from Pundit::NotAuthorizedError, with: :redirect_because_not_authorized

  private

  # Přihlašovací a registrační stránky nemají sidebar, protože ještě není kdo je vidí.
  def layout_for_current_page
    devise_controller? ? "plain" : "application"
  end

  # Všechna data se dotazují přes current_account.*, nikdy přes Model.find(params[:id]).
  # Díky tomu se data jednoho účtu nemůžou objevit u druhého.
  def current_account
    Current.account
  end

  def set_current_account
    Current.account = current_user&.account
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone, { account_attributes: [ :name ] } ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name, :phone ])
  end

  def redirect_because_not_authorized
    redirect_back fallback_location: root_path, alert: "Na tuhle stránku nemáš oprávnění."
  end
end
