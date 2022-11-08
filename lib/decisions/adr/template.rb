module Decisions
  module ADR
    class Template < Decisions::Template
      INITIAL_STATE_OPTIONS = ["Proposed", "Accepted"].freeze

      DEFAULTS = {
        context: "* We need to record the architectural decisions made on this project.",
        decision: "* The change that we're proposing or have agreed to implement.",
        consequences: "* What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated."
      }.freeze

      def render(object)
        ERB.new(File.read(@path)).result(object)
      end

    end
  end
end
