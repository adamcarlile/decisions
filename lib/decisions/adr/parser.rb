module Decisions
  module ADR
    class Parser
      REGEX = /(\#{1,6}[^\n]+(?=\n))([^#]*)/

      def initialize(path)
        @path = path
      end

      def results
        structured_document
      end

      def [](key)
        structured_document[key]
      end

      private

      def structured_document
        @structured_document ||= begin 
          hash = {}
          array = content.scan(REGEX)
          array.shift.tap do |x|
            x[0].match(/(\d*)\. (.*)/).tap do |m|
              hash[:id] = m[1].to_i
              hash[:title] = m[2]
            end
            hash[:date] = Date.parse(x[1].match(/Date: (.*)/)[1])
          end
          array.each do |fragment|
            hash[fragment.first.match(/\#{1,6} (.*)/)[1].downcase.to_sym] = fragment[1].strip.split("\n").map {|x| x.gsub(/^\* /, "")}
          end
          hash
        end
      end

      def content
        @content ||= File.read(@path)
      end

    end
  end
end