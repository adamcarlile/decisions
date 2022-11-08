require "thor"
require "tty-prompt"
require "tty-table"

require "decisions/cli/adr"

module Decisions
  module CLI
    class Interface < Thor

      desc "adr SUBCOMMAND ...ARGS", "Manage ADR's directly"
      subcommand "adr", Decisions::CLI::ADR

    end
  end
end