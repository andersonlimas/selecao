require_relative 'base'

module Services
  class CreateSession
    include Base

    Session = Struct.new(:start_at, :lectures)

    def initialize(lecture_list)
      @lecture_list = lecture_list
    end

    def call
      remaning_duration_block = duration_block_in_minutes

      session_lectures = lecture_list.reduce([]) do |memo, lecture|
        remaning_duration_block -= lecture.duration

        break memo if remaning_duration_block < 0

        memo << lecture
      end

      Session.new(start_at, session_lectures)
    end

    private

    attr_reader :lecture_list

    # --- Abstracted methods ---
    def start_at;end
    def duration_block_in_minutes;end
  end
end
