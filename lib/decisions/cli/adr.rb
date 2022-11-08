module Decisions
  module CLI
    class ADR < Thor

      desc "new", "Create new ADR documents"
      option :supercede, type: :boolean, banner: "supercede", aliases: :s
      def new()
        prompt = TTY::Prompt.new

        superceded_adr = filter_prompt("Which ADR does this supercede?", prompt: prompt) if options[:supercede]

        params = prompt.collect do
          key(:title).ask("What is the Title?")
          key(:status).select("What is the Status of the ADR?", Decisions::ADR::Template::INITIAL_STATE_OPTIONS)
          Decisions::ADR::Template::DEFAULTS.each do |key, value|
            key(key).multiline("#{key.to_s.capitalize}?") do |q|
              q.default(value)
              q.help("Press ctrl+d to exit")
            end
          end
        end

        directory.create_decision(**params).tap do |d|
          puts "Created #{d.id} - #{d.title}"
          if options[:supercede]
            superceded_adr.supercede!(d) 
            d.supercedes!(superceded_adr)
            
            superceded_adr.save!
            d.save!
          end
        end
      end

      desc "deprecate", "Deprecate an ADR"
      def deprecate
        prompt = TTY::Prompt.new
        deprecated_adr = filter_prompt("Which ADR would you like to deprecate?", prompt: prompt)

        deprecated_adr.deprecate!
        deprecated_adr.save!
      end

      desc "accept", "Accept an ADR"
      def accept
        prompt = TTY::Prompt.new
        accepted_adr = filter_prompt("Which ADR would you like to accept?", prompt: prompt)

        accepted_adr.accept!
        accepted_adr.save!
      end

      desc "reject", "Reject an ADR"
      def reject
        prompt = TTY::Prompt.new
        rejected_adr = filter_prompt("Which ADR would you like to reject?", prompt: prompt)

        rejected_adr.reject!
        rejected_adr.save!
      end

      desc "link", "Link two or more ADRs"
      def link
        if decision_list.length < 2
          puts "Not enough decisions to link"
          return 
        end
        prompt = TTY::Prompt.new
        linkable_adrs = prompt.multi_select("Which ADRs would you like to link together?", decision_list, filter: true)
        decisions = directory.decisions.slice(*linkable_adrs).values
        decisions.each {|doc| doc.link!(*decisions); doc.save!}
      end

      desc "list", "Show the list of ADRs"
      def list
        table = TTY::Table.new(header: ["ID", "Title", "Date", "Status"])
        directory.decisions.values.each do |d|
          table << [d.id, d.title, d.date.to_s, d.status.last]
        end
        puts table.render(:unicode, resize: true)
      end

      private

      def directory
        @directory ||= Decisions::Directory.new
      end

      def decision_list
        directory.decisions.map {|k, v| ["#{v.id} - #{v.title}", v.id]}.to_h
      end

      def filter_prompt(question, prompt:)
        directory.decisions[prompt.select(question, decision_list, filter: true)]
      end

    end
  end
end