class VisitsController < ApplicationController
  before_action :set_job, only: [ :create, :destroy ]
  before_action :set_visit, only: [ :update ]

  # Podklad pro kalendář. FullCalendar si sám doplní ?start= a ?end=.
  def index
    visits = current_account.visits
                            .includes(:user, job: [ :client, :property ])
                            .starting_between(requested_range_start, requested_range_end)
                            .chronological

    render json: visits.map { |visit| calendar_event_for(visit) }
  end

  def create
    visit = @job.visits.new(visit_params)

    if visit.save
      redirect_to @job, notice: "Termín byl naplánován."
    else
      redirect_to @job, alert: visit.errors.full_messages.to_sentence
    end
  rescue ActiveRecord::StatementInvalid
    redirect_to @job, alert: "Technik už má v tuhle dobu jiný termín."
  end

  # Přetažení termínu v kalendáři.
  def update
    if @visit.update(visit_params)
      head :no_content
    else
      render json: { error: @visit.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  rescue ActiveRecord::StatementInvalid
    render json: { error: "Technik už má v tuhle dobu jiný termín." }, status: :unprocessable_entity
  end

  def destroy
    @job.visits.find(params[:id]).destroy
    redirect_to @job, notice: "Termín byl zrušen."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:job_id])
  end

  def set_visit
    @visit = current_account.visits.find(params[:id])
  end

  def requested_range_start
    params[:start].present? ? Time.zone.parse(params[:start]) : Time.current.beginning_of_week
  end

  def requested_range_end
    params[:end].present? ? Time.zone.parse(params[:end]) : Time.current.end_of_week
  end

  def calendar_event_for(visit)
    {
      id: visit.id,
      title: visit.job.title,
      start: visit.starts_at.iso8601,
      end: visit.ends_at.iso8601,
      url: job_path(visit.job),
      backgroundColor: technician_color(visit.user),
      borderColor: technician_color(visit.user),
      extendedProps: {
        client: visit.job.client.name,
        place: visit.job.property&.display_label,
        technician: visit.user&.full_name || "Nepřiřazeno"
      }
    }
  end

  TECHNICIAN_COLORS = %w[#0C6E6B #3B6E4A #6E5B8A #1B1E1C].freeze
  UNASSIGNED_COLOR = "#8A8D86".freeze
  private_constant :TECHNICIAN_COLORS, :UNASSIGNED_COLOR

  # Stejné pořadí barev jako u avatarů, aby technik měl všude stejnou barvu.
  def technician_color(user)
    return UNASSIGNED_COLOR if user.nil?

    TECHNICIAN_COLORS[user.id % TECHNICIAN_COLORS.size]
  end

  def visit_params
    params.expect(visit: [ :user_id, :starts_at, :ends_at, :status, :note ])
  end
end
