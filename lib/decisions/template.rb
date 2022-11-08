module Decisions
  class Template
    MAPPING = Hash.new('Decisions::Template').merge({
      adr: 'Decisions::ADR::Template'
    }.freeze)

    attr_reader :path

    def initialize(path)
      @path = Pathname.new(path)
    end

    def render
      raise NotImplemented
    end

  end
end