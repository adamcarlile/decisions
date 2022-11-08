module Decisions
  class Directory
    attr_reader :path, :config

    def initialize(path = Dir.pwd)
      @path   = path
      @config = Decisions.config
    end

    def decisions
      @decisions ||= Pathname.new(path).glob("*#{Decisions::ADR::Document::FILE_SUFFIX}").map do |x| 
        doc = Decisions::ADR::Document.parse(x)
        [doc.id, doc]
      end.to_h
    end

    def create_decision(title:, **args)
      doc = Decisions::ADR::Document.build(title: title, id: next_id, dir: @path, **args)
      doc.tap do |x|
        x.save!
        decisions[x.id] = x
      end
    end

    private

    def next_id
      ids.max.succ
    end

    def ids
      [0] + decisions.keys
    end

  end
end