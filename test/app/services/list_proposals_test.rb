require 'minitest/autorun'
require './app/services/list_proposals'

describe ::Services::ListProposals, '#call' do

  describe 'when given an invalid proposal_path' do

    it 'raise an error' do
      subject = subject_instance('invalid_path')

      error = lambda { subject.call }.must_raise ArgumentError

      _(error.message).must_equal 'Invalid Proposal Path'
    end
  end

  describe 'when given a valid proposal_path' do
    describe 'when proposal file is empty' do

      it 'raise an error' do
        subject = subject_instance('test/support/proposals_empty.txt')

        error = lambda { subject.call }.must_raise ArgumentError

        _(error.message).must_equal 'Invalid Proposal: Empty file'
      end
    end

    describe 'when proposal file has proposals' do

      it 'return a list of proposals' do
        subject = subject_instance('test/support/proposals.txt')

        expected_result = [
          'How to be Roman 60min',
          'How to be rich 45min',
          'Not anymore 30min',
          'Ruby is Awesome lightning',
          'Errors in Ruby 45min'
        ]

        _(subject.call).must_equal expected_result
      end
    end
  end

  def subject_instance(proposal_path)
    @subject ||= ::Services::ListProposals.new(proposal_path)
  end
end
