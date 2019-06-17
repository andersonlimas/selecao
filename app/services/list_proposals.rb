require_relative 'base'

module Services
  class ListProposals
    include Base

    def initialize(proposal_path)
      @proposal_path = proposal_path
    end

    def call
      validate_proposal_path

      File.readlines(proposal_path).map(&:strip)
    end

    private

    attr_reader :proposal_path

    def validate_proposal_path
      raise_msg('Invalid Proposal Path')        unless File.exist?(proposal_path)
      raise_msg('Invalid Proposal: Empty file') if     File.empty?(proposal_path)
    end
  end
end
