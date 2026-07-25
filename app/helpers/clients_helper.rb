module ClientsHelper
  def client_type_options
    Client::CLIENT_TYPES.map { |client_type| [ t("clients.types.#{client_type}"), client_type ] }
  end
end
