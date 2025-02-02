require_relative '../services/list_proposals'
require_relative '../services/create_lectures'
require_relative '../services/create_morning_session'
require_relative '../services/create_afternoon_session'
require_relative '../services/create_track'

module UseCases
  class OrganizeConference

    def initialize(proposals_path)
      @proposals_path = proposals_path
    end

    def call
      proposal_list          = provide_list_proposals(proposals_path).call
      lecture_list           = provide_create_lectures(proposal_list).call

      tracks = create_tracks(lecture_list)

      provide_create_conference(tracks)
    end

    private

    attr_reader :proposals_path

    def create_tracks(lecture_list, index = 0, tracks = [])
      track_names = ('A'..'Z').to_a

      morning_session        = provide_create_morning_session(lecture_list).call
      remaining_lecture_list = lecture_list - morning_session.lectures
      afternoon_session      = provide_create_afternoon_session(remaining_lecture_list).call
      remaining_lecture_list = remaining_lecture_list  - afternoon_session.lectures

      tracks << provide_create_track("Track #{track_names[index]}", morning_session, afternoon_session).call

      return tracks if remaining_lecture_list.empty?

      index += 1

      create_tracks(remaining_lecture_list, index, tracks)
    end

    def provide_list_proposals(proposals_path)
      ::Services::ListProposals.new(proposals_path)
    end

    def provide_create_lectures(proposal_list)
      ::Services::CreateLectures.new(proposal_list)
    end

    def provide_create_morning_session(lecture_list)
      ::Services::CreateMorningSession.new(lecture_list)
    end

    def provide_create_afternoon_session(lecture_list)
      ::Services::CreateAfternoonSession.new(lecture_list)
    end

    def provide_create_track(track_name, morning_session, afternoon_session)
      ::Services::CreateTrack.new(track_name, morning_session, afternoon_session)
    end

    def provide_create_conference(tracks)
      tracks.map(&:to_s).join("\n")
    end
  end
end
