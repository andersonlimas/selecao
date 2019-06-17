require_relative 'base'

module Services
  class CreateTrack
    include Base

    Event = Struct.new(:start_at, :title) do
      def to_s
        "#{start_at} #{title}"
      end
    end

    Track = Struct.new(:name, :morning_events, :afternoon_events) do
      def to_s
        <<~DESC
#### #{name}:
#{formmated_events(morning_events)}

#{formmated_events(afternoon_events)}
      DESC
      end

      private
      def formmated_events(events)
        events.map(&:to_s).join("\n\n")
      end
    end

    def initialize(track_name, morning_session, afternoon_session)
      @track_name        = track_name
      @morning_session   = morning_session
      @afternoon_session = afternoon_session
    end

    def call
      morning_events   = build_formatted_events_from_session(:morning, morning_session)
      afternoon_events = build_formatted_events_from_session(:afternoon,afternoon_session)


      Track.new(track_name, morning_events, afternoon_events)
    end

    private

    attr_reader :track_name, :morning_session, :afternoon_session

    def build_formatted_events_from_session(type, session)
      start_at = session.start_at

      events = session.lectures.map do |lecture|
        start_at_formatted = start_at.strftime("%k:%M").strip
        # to sum minutes is necessary multiply by 60
        start_at = start_at + 60 * lecture.duration

        Event.new(start_at_formatted, lecture.title)
      end

      events << extra_event = send("extra_event_#{type}", start_at)

      events
    end

    def extra_event_morning(_)
      Event.new('12:00', 'Almoço')
    end

    def extra_event_afternoon(start_at)
      four_pm = Time.new(start_at.year, start_at.month, start_at.day, 16,0,0)

      start_networking = '16:00' if start_at <= four_pm
      start_networking = start_at.strftime("%k:%M").strip if start_at > four_pm

      Event.new(start_networking, 'Evento de Networking')
    end
  end
end
