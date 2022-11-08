module Decisions
  module ADR
    class StatusManager
      DOCUMENT_STATES = [:accepted, :proposed, :rejected, :deprecated]

      REFERENCE_STATES = [:superceded, :supercedes, :linked]

      def initialize(states)
        @states = build_states([states].flatten)
      end

      def render
        output = [
          document_states[:proposed].map(&:render),
          document_states[:accepted].map(&:render),
          document_states[:rejected].map(&:render),
          document_states[:deprecated].map(&:render),
          "---\n"
        ]
        output << [reference_states[:superceded].map(&:render), "\n"] if reference_states[:superceded].any?
        output << [reference_states[:supercedes].map(&:render), "\n"] if reference_states[:supercedes].any?
        output << [reference_states[:linked].map(&:render)] if reference_states[:linked].any?

        output.reject(&:empty?).compact.flatten.join
      end

      def accept!
        return if document_states[:accepted].any?
        write_state(:accepted, collection: document_states)
      end

      def reject!
        return if document_states[:rejected].any?
        write_state(:rejected, collection: document_states)
      end

      def deprecate!(document)
        return if document_states[:rejected].any?
        write_state(:deprecated, collection: document_states)
      end

      def supercede!(document)
        write_state(:superceded, strikeout: false, collection: reference_states, content: "Superceded by #{document.markdown_link}")
      end

      def supercedes!(document)
        write_state(:supercedes, strikeout: false, collection: reference_states, content: "Supercedes #{document.markdown_link}")
      end

      def link!(document)
        write_state(:linked, strikeout: false, collection: reference_states, content: "Linked to #{document.markdown_link}")
      end

      private

      def document_states
        @document_states ||= Hash.new { |h, k| h[k] = [] }.merge(@states.slice(*DOCUMENT_STATES))
      end

      def reference_states
        @reference_states ||= Hash.new { |h, k| h[k] = [] }.merge(@states.slice(*REFERENCE_STATES))
      end

      def write_state(status, strikeout: true, collection:, content: status.to_s.capitalize)
        collection.values.flatten.each(&:strikeout!) if strikeout
        collection[status] << Decisions::ADR::State.new(content: content)
      end

      def build_states(states)
        states.map {|x| Decisions::ADR::State.new(content: x)}.group_by {|x| x.state }
      end

    end
  end
end
