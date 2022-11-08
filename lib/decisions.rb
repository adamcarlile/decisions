# frozen_string_literal: true
require "pry"
require "pathname"
require "fileutils"
require "erb"
require "date"
require "forwardable"

require "decisions/directory"
require "decisions/template"
require "decisions/adr/state"
require "decisions/adr/status_manager"
require "decisions/adr/document"
require "decisions/adr/parser"
require "decisions/adr/template"
require "decisions/version"


module Decisions
  class Error < StandardError; end

  module_function

  def config
    @config ||= {
      template_directory: '.templates'
    }
  end

  def templates
    @templates ||= root_path.join('templates').glob('*.md.erb').map do |x|
      key = x.basename.to_s.split('.').first.to_sym
      [key, Object.const_get(Decisions::Template::MAPPING[key]).new(x)]
    end.to_h
  end

  def root_path
    Pathname.new(File.join(__dir__, '..')).realpath
  end

end
