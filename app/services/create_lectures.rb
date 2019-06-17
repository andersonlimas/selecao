require_relative 'base'

module Services
  class CreateLectures
    include Base

    Lecture = Struct.new(:title, :duration)

    def initialize(proposal_list)
      @proposal_list = proposal_list
    end

    def call
      proposal_list.map { |proposal| Lecture.new(proposal, extract_duration(proposal)) }
    end

    private

    attr_reader :proposal_list

    def extract_duration(proposal)
      duration = proposal.match(/(\d*)min$/)

      return duration[1].to_i if duration

      return lightning_minutes = 5 if proposal.match?(/lightning$/)

      raise_msg('Not found duration for this Proposal')
    end
  end
end
