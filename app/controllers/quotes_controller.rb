class QuotesController < ApplicationController
  before_action :set_job

  # Vystavení nabídky ze zakázky — vznikne nabídka a zakázka se posune
  # do stavu „nabídka odeslána".
  def create
    unless @job.can_change_status_to?("quote_sent")
      redirect_to @job, alert: "Nabídku jde vystavit jen z naceněné zakázky."
      return
    end

    if @job.job_items.empty?
      redirect_to @job, alert: "Zakázka nemá žádné položky, není z čeho udělat nabídku."
      return
    end

    @job.issue_quote!
    redirect_to @job, notice: "Nabídka je vystavená. Pošli zákazníkovi odkaz na client hub."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:job_id])
  end
end
