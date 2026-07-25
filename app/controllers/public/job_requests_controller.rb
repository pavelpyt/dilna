module Public
  class JobRequestsController < BaseController
    before_action :set_account_from_slug

    def new
      @job_request_form = JobRequestForm.new
    end

    def create
      @job_request_form = JobRequestForm.new(job_request_form_params)

      unless @job_request_form.valid?
        render :new, status: :unprocessable_entity
        return
      end

      PublicRequests::JobCreator.new(current_account).create_job_from_public_form(@job_request_form)
      redirect_to public_job_request_sent_path(current_account.slug)
    end

    def sent
    end

    private

    def set_account_from_slug
      Current.account = Account.find_by!(slug: params[:account_slug])
    end

    def job_request_form_params
      params.expect(job_request_form: [ :client_name, :email, :phone, :street, :city,
                                        :postal_code, :title, :description ])
    end
  end
end
