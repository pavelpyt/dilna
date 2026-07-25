module Sms
  # Hotové texty, které řemeslník posílá pořád dokola. Jsou tady, aby se
  # neskládaly v šabloně a daly se změnit na jednom místě.
  module Templates
    NAMES = %w[on_the_way visit_confirmed invoice_issued].freeze

    def self.body_for(name, job)
      case name
      when "on_the_way"
        "Dobrý den, jsme na cestě k vám na adresu #{job.property&.full_address || "domluvené místo"}. #{job.account.name}"
      when "visit_confirmed"
        "Dobrý den, potvrzujeme termín #{visit_time(job)}. #{job.account.name}"
      when "invoice_issued"
        "Dobrý den, vystavili jsme fakturu #{job.invoice&.number} na #{job.total_with_vat.round} Kč. #{job.account.name}"
      else
        raise ArgumentError, "Neznámá šablona SMS: #{name}"
      end
    end

    def self.visit_time(job)
      next_visit = job.next_visit
      return "podle domluvy" if next_visit.nil?

      I18n.l(next_visit.starts_at, format: :long)
    end
  end
end
