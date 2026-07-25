module Public
  # Stránka, kterou vidí zákazník po kliknutí na odkaz z SMS nebo e-mailu.
  # Žádné přihlášení, jen náhodný token — a ten pouští k jediné zakázce.
  class ClientHubController < BaseController
    include FindsJobByPublicToken

    def show
      @quote = @job.current_quote
      @next_visit = @job.next_visit
      @invoice = @job.invoice
    end
  end
end
