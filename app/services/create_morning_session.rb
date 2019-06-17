require_relative 'base'
require_relative 'create_session'

module Services
  class CreateMorningSession < CreateSession

    private

    # This session will Start at 9am
    def start_at
      today = Time.now
      Time.new(today.year, today.month, today.day, 9,0,0)
    end

    # Block with 4 hours
    def duration_block_in_minutes
      240
    end
  end
end
