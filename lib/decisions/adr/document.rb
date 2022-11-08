module Decisions
  module ADR
    class Document
      extend Forwardable
      FILE_SUFFIX = ".adr.md".freeze

      def_delegators :@status, :accept!, :reject!, :deprecate!, :supercede!, :supercedes!

      class << self
        def parse(path)
          doc = Decisions::ADR::Parser.new(path)
          new(path: path, **doc.results)
        end

        def build(title:, id:, dir:, **args)
          path = Pathname.new(File.join(dir, filename(id, title)))
          new(title: title, id: id, path: path, **args)
        end

        private

        def filename(id, title)
          id = "%04d" % id
          title = title.gsub(/[^\w\s_-]+/, '')
                       .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
                       .gsub(/\s+/, '-')
                       .downcase + FILE_SUFFIX
          [id, title].join('-')
        end
      end

      attr_reader :id, :path, :date, :status
      attr_accessor :title, :decision, :consequences, :context

      def initialize(id:, title:, date: Time.now, status:, context: nil, decision: nil, consequences: nil, path: nil)
        @id, @title, @date, @context, @decision, @consequences = id, title, date, context, decision, consequences
        @status = Decisions::ADR::StatusManager.new(status)
        @path = path
      end

      def filename
        @path.basename
      end

      def markdown_link
        "[#{id} - #{title}](#{filename})"
      end

      def link!(*documents)
        documents.reject {|x| x == self }.each do |doc|
          @status.link!(doc)
        end
      end

      def save!
        File.write(@path, render)
      end

      private

      def render
        template.render(binding)
      end

      def template
        @template ||= Decisions.templates[:adr]
      end

    end
  end
end