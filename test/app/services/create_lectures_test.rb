require 'minitest/autorun'
require './app/services/create_lectures'

describe ::Services::CreateLectures, '#call' do

  describe 'when given a valid proposal_list' do

    describe 'when all proposals have duration' do

      it 'return a list of lectures' do
        proposal_list = [
          'How to be Roman 60min',
          'How to be rich 45min',
          'Not anymore 30min',
          'Ruby is Awesome lightning',
          'Errors in Ruby 45min'
        ]

        subject = subject_instance(proposal_list)

        expected_result = [
          build_lecture('How to be Roman 60min', 60),
          build_lecture('How to be rich 45min', 45),
          build_lecture('Not anymore 30min', 30),
          build_lecture('Ruby is Awesome lightning', 5),
          build_lecture('Errors in Ruby 45min', 45)
        ]

        _(subject.call).must_equal expected_result
      end
    end

    describe 'when one proposal have NO duration' do

      it 'raise an error' do
        proposal_list = [
          'How to be Roman 60min',
          'Ruby is Awesome lightning',
          'Errors in Ruby'
        ]
        subject = subject_instance(proposal_list)

        error = lambda { subject.call }.must_raise ArgumentError

        _(error.message).must_equal 'Not found duration for this Proposal'
      end
    end
  end

  def subject_instance(proposal_list)
    @subject ||= ::Services::CreateLectures.new(proposal_list)
  end

  def build_lecture(title, duration)
    ::Services::CreateLectures::Lecture.new(title, duration)
  end
end
