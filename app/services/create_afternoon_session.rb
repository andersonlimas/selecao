require_relative 'base'
require_relative 'create_session'

module Services
  class CreateAfternoonSession < CreateSession

    private

    # This session will Start at 1pm
    def start_at
      today = Time.now
      Time.new(today.year, today.month, today.day, 13,0,0)
    end

    # Block with 4 hours
    def duration_block_in_minutes
      240
    end
  end
end
