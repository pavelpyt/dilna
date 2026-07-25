module Public
  # Zaplacení faktury ze zákazníkovy stránky. V ostrém provozu sem uživatele
  # pošle Stripe Checkout, v MVP je to jedno kliknutí.
  class PaymentsController < BaseController
    include FindsJobByPublicToken

    def create
      invoice = @job.invoice

      if invoice.nil? || invoice.paid?
        redirect_to client_hub_path(params[:token]), alert: "Není co platit."
        return
      end

      Payments::PaymentRecorder.new.record_successful_payment(invoice)
      redirect_to client_hub_path(params[:token]), notice: "Děkujeme, platba dorazila."
    end
  end
end
