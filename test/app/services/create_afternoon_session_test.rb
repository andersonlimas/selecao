require 'minitest/autorun'
require './app/services/create_afternoon_session'
require './app/services/create_lectures'

describe ::Services::CreateAfternoonSession, '#call' do

  describe 'when given a valid lecture_list' do

    describe 'when given lectures which total of duration is SMALLER than 240 minutes' do

      it 'return a morning session with your lectures' do
        lecture_list = [
          build_lecture('How to be Roman 60min', 60),
          build_lecture('How to be rich 45min', 45),
          build_lecture('Not anymore 30min', 30),
          build_lecture('Ruby is Awesome lightning', 5),
          build_lecture('Errors in Ruby 45min', 45)
        ]

        subject  = subject_instance(lecture_list)
        response = subject.call

        _(response.start_at.strftime("%k:%M").strip).must_equal '13:00'
        _(response.lectures).must_equal lecture_list
      end
    end

    describe 'when given lectures which total of duration is BIGGER than 240 minutes' do

      it 'return a morning session with your lectures' do
        lecture_list = [
          build_lecture('How to be Roman 60min', 60),
          build_lecture('How to be rich 45min', 45),
          build_lecture('Not anymore 30min', 30),
          build_lecture('Ruby is Awesome lightning', 5),
          build_lecture('Errors in Ruby 45min', 45),
          build_lecture('How to be a better programmer 55min', 55),
        ]

        subject  = subject_instance(lecture_list)
        response = subject.call

        _(response.start_at.strftime("%k:%M").strip).must_equal '13:00'

        expected_lectures = lecture_list.dup
        expected_lectures.pop
        _(response.lectures).must_equal expected_lectures
      end
    end

  end

  def subject_instance(proposal_list)
    @subject ||= ::Services::CreateAfternoonSession.new(proposal_list)
  end

  def build_lecture(title, duration)
    ::Services::CreateLectures::Lecture.new(title, duration)
  end
end
