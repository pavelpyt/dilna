module Public
  # Zákazník nabídku buď schválí, nebo zamítne. Jedna akce, rozhodnutí je parametr —
  # nedělám z toho dvě nestandardní slovesa.
  class QuoteDecisionsController < BaseController
    include FindsJobByPublicToken

    def create
      quote = @job.current_quote

      unless quote&.waiting_for_customer?
        redirect_to client_hub_path(params[:token]), alert: "Tahle nabídka už není ke schválení."
        return
      end

      if params[:decision] == "approve"
        quote.approve_by_customer!
        redirect_to client_hub_path(params[:token]), notice: "Děkujeme, nabídku máme schválenou. Ozveme se s termínem."
      else
        quote.reject_by_customer!
        redirect_to client_hub_path(params[:token]), notice: "Nabídku jsme označili jako zamítnutou."
      end
    end
  end
end
