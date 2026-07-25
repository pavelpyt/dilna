# Pruh stavů na detailu zakázky. Ukazuje hlavní cestu; hotové kroky zeleně,
# aktuální petrolově, zbytek šedě.
class JobStatusFlowComponent < ViewComponent::Base
  def initialize(job:)
    @job = job
  end

  def steps
    Job::MAIN_FLOW_STATUSES.each_with_index.map do |status, index|
      { status: status, number: index + 1, state: state_of(status) }
    end
  end

  def render?
    @job.on_main_flow?
  end

  private

  def state_of(status)
    current_position = Job::MAIN_FLOW_STATUSES.index(@job.status)
    status_position = Job::MAIN_FLOW_STATUSES.index(status)

    return :done if status_position < current_position
    return :current if status_position == current_position

    :todo
  end
end
