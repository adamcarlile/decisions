module Decisions
  module ADR
    class State
      STRIKEOUT_STRING = "~~".freeze
      STRIKEOUTABLE_STATES = [:accepted, :proposed]
      STATE_MATCHER = /([\w]+)/
      BULLET_PREFIX = /^[\s|*]*/

      def initialize(content:)
        @content = content.gsub(BULLET_PREFIX, "")
      end

      def render
        "* #{@content}\n"
      end

      def state
        @state ||= @content.match(STATE_MATCHER).to_s.downcase.to_sym
      end

      def strikeoutable?
        STRIKEOUTABLE_STATES.include?(state)
      end

      def struckout?
        !!(@content =~ /#{STRIKEOUT_STRING}.*#{STRIKEOUT_STRING}/)
      end

      def strikeout!
        return if struckout?
        @content = [STRIKEOUT_STRING, @content, STRIKEOUT_STRING].join('') if strikeoutable? 
      end

    end
  end
end