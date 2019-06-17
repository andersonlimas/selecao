require 'minitest/autorun'
require './app/services/create_track'
require './app/services/create_lectures'
require './app/services/create_session'

describe ::Services::CreateTrack, '#call' do

  describe 'when afternoon session finishs before 4pm' do

    it 'return a Track' do
      morning_lecture_list = [
        build_lecture('How to be Roman 60min', 60),
        build_lecture('How to be rich 45min', 45),
      ]

      afternoon_lecture_list = [
        build_lecture('Not anymore 30min', 30),
        build_lecture('Ruby is Awesome lightning', 5),
      ]

      morning_session   = build_session(morning_lecture_list, 9)
      afternoon_session = build_session(afternoon_lecture_list, 13)

      subject  = subject_instance('Track A', morning_session, afternoon_session)
      track = subject.call

      expected_track_desc = <<~DESC
#### Track A:
9:00 How to be Roman 60min

10:00 How to be rich 45min

12:00 Almoço

13:00 Not anymore 30min

13:30 Ruby is Awesome lightning

16:00 Evento de Networking
      DESC

      _(track.to_s).must_equal expected_track_desc
    end
  end

  describe 'when afternoon session finishs at 4pm' do

    it 'return a Track' do
      morning_lecture_list = [
        build_lecture('How to be Roman 60min', 60),
        build_lecture('How to be rich 45min', 45),
      ]

      afternoon_lecture_list = [
        build_lecture('Not anymore 60min', 60),
        build_lecture('Hello World 60min', 60),
        build_lecture('Hail Life 60min', 60),
      ]

      morning_session   = build_session(morning_lecture_list, 9)
      afternoon_session = build_session(afternoon_lecture_list, 13)

      subject  = subject_instance('Track A', morning_session, afternoon_session)
      track = subject.call

      expected_track_desc = <<~DESC
#### Track A:
9:00 How to be Roman 60min

10:00 How to be rich 45min

12:00 Almoço

13:00 Not anymore 60min

14:00 Hello World 60min

15:00 Hail Life 60min

16:00 Evento de Networking
      DESC

      _(track.to_s).must_equal expected_track_desc
    end
  end

  describe 'when afternoon session finishs after 4pm' do

    it 'return a Track' do
      morning_lecture_list = [
        build_lecture('How to be Roman 60min', 60),
        build_lecture('How to be rich 45min', 45),
      ]

      afternoon_lecture_list = [
        build_lecture('Not anymore 60min', 60),
        build_lecture('Hello World 60min', 60),
        build_lecture('Hail Life 60min', 60),
        build_lecture('Ruby Rocks 65min', 65),
      ]

      morning_session   = build_session(morning_lecture_list, 9)
      afternoon_session = build_session(afternoon_lecture_list, 13)

      subject  = subject_instance('Track A', morning_session, afternoon_session)
      track = subject.call

      expected_track_desc = <<~DESC
#### Track A:
9:00 How to be Roman 60min

10:00 How to be rich 45min

12:00 Almoço

13:00 Not anymore 60min

14:00 Hello World 60min

15:00 Hail Life 60min

16:00 Ruby Rocks 65min

17:05 Evento de Networking
      DESC

      _(track.to_s).must_equal expected_track_desc
    end
  end

  def subject_instance(track_name, morning_session, afternoon_session)
    @subject ||= ::Services::CreateTrack.new(track_name, morning_session, afternoon_session)
  end

  def build_session(lecture_list, start_hour)
      today    = Time.now
      start_at = Time.new(today.year, today.month, today.day, start_hour,0,0)

    ::Services::CreateSession::Session.new(start_at, lecture_list)
  end

  def build_lecture(title, duration)
    ::Services::CreateLectures::Lecture.new(title, duration)
  end
end
