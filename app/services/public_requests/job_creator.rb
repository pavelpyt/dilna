module PublicRequests
  # Z odeslaného veřejného formuláře udělá klienta, jeho adresu a zakázku
  # ve stavu „poptávka". Víckrokové vytvoření, proto service objekt.
  class JobCreator
    def initialize(account)
      @account = account
    end

    def create_job_from_public_form(job_request_form)
      ActiveRecord::Base.transaction do
        client = find_or_create_client(job_request_form)
        property = find_or_create_property(client, job_request_form)

        @account.jobs.create!(
          client: client,
          property: property,
          title: job_request_form.title,
          description: job_request_form.description,
          status: "inquiry"
        )
      end
    end

    private

    # Stálý zákazník se pozná podle telefonu nebo e-mailu. Když se nenajde,
    # založí se nový — sloučit dvě karty jde ručně, rozdělit hůř.
    def find_or_create_client(job_request_form)
      existing_client = find_client_by_contact(job_request_form)
      return existing_client if existing_client

      @account.clients.create!(
        name: job_request_form.client_name,
        client_type: "person",
        email: job_request_form.email,
        phone: job_request_form.phone
      )
    end

    def find_client_by_contact(job_request_form)
      return @account.clients.find_by(phone: job_request_form.phone) if job_request_form.phone.present?

      @account.clients.find_by(email: job_request_form.email) if job_request_form.email.present?
    end

    def find_or_create_property(client, job_request_form)
      existing_property = client.properties.find_by(street: job_request_form.street, city: job_request_form.city)
      return existing_property if existing_property

      client.properties.create!(
        street: job_request_form.street,
        city: job_request_form.city,
        postal_code: job_request_form.postal_code
      )
    end
  end
end
