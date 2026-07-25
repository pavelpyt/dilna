class SmsMessagesController < ApplicationController
  before_action :set_job

  def create
    if @job.client.phone.blank?
      redirect_to @job, alert: "Klient nemá telefon, SMS nemáme kam poslat."
      return
    end

    template_name = params[:template_name]

    unless Sms::Templates::NAMES.include?(template_name)
      redirect_to @job, alert: "Neznámá šablona SMS."
      return
    end

    Sms::MessageSender.new.send_sms_to_client(
      client: @job.client,
      job: @job,
      template_name: template_name,
      body: Sms::Templates.body_for(template_name, @job)
    )

    redirect_to @job, notice: "SMS je ve frontě k odeslání."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:job_id])
  end
end
