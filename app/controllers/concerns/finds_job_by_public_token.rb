# Sdílí client hub a rozhodnutí o nabídce: obojí pouští dovnitř jen platný token
# a obojí si podle něj nastaví firmu.
module FindsJobByPublicToken
  extend ActiveSupport::Concern

  included do
    before_action :set_job_from_token
  end

  private

  def set_job_from_token
    public_token = PublicToken.still_valid.find_by!(token: params[:token])

    @job = public_token.job
    Current.account = @job.account
  end
end
