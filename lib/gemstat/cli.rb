module Gemstat
  class GemstatTasks < Thor
    class_option :debug, :type => :string, :aliases => '-d', :desc => "Debug mode"
    default_task :summary

    desc "update", "Update internal schema information"
    def update(exp=nil)
      puts "This task will download more than hundred thousand gems(which will require huge network traffic to download tons of gem binary files). Do you want to proceed?[Y/n]"
      if $stdin.gets.chomp.upcase == "Y" then
        fetcher = Gem::Mirror::Fetcher.new(:retries => 3, :skiperror => true)
        (`gem list -r #{exp} | sed 's/ (/(/g'`).each_line do |gem|
          gem_name = gem.sub(/\(.*/,'')
          dest = "#{File.dirname(__FILE__)}/cache/gemfiles/#{gem[0].downcase}/#{gem.chomp.sub(/\(/,':').sub(/,.*/,'').sub(/\)/,'').sub(/\s.*/,'')}"
          fetcher.fetch "http://rubygems.org/gems/#{gem.chomp.sub(/\(/,'-').sub(/,.*/,'').sub(/\)/,'').sub(/\s.*/,'')}.gem", "#{dest}.gem"
          `mkdir #{dest}; tar xvf #{dest}.gem -C #{dest}; gzip -dc #{dest}/metadata.gz | grep -e "\s\sname:" | sed 's/\s\sname: //g' | xargs -I% echo "gem '%'" | grep -v -e "gem '.* .*'" >> #{dest}/Gemfile`
          #`mkdir #{dest}/tmp; tar xzvf #{dest}/data.tar.gz -C #{dest}/tmp; cp #{dest}/tmp/Gemfile #{dest}/Gemfile; cp #{dest}/tmp/*.gemspec #{dest}/`
          `rm -rf #{dest}.gem #{dest}/metadata.gz #{dest}/data.tar.gz #{dest}/checksums.yaml.gz`
        end
      end
    end

    desc "version", "Show version number"
    def version
      puts Gemstat::VERSION
    end

    desc "list", "List gem information from locally cached datasource"
    option :directory, :type=>:string, :aliases=>'-d', :default=>File.dirname(__FILE__), :desc=>"The folder path to search Gemfile and .gemspec files(recursively)"
    def list
      population = Population.new(options[:directory])

      puts "  " + "-"*44
      puts "  Gemfile                Gems in Use"
      puts "  " + "-"*44
      population.dependencies.sort{|x,y|x.name <=> y.name}.each {|item|
        if item.gems.count==0 then
          count = "   -"
        else
          count = "#{item.gems.count.to_s[0..3].rjust(4)} " + pluralize(item.gems.count, "gem")
        end
        puts "  #{item.name[0..43].ljust(44)} #{count} "
      }
      puts "  " + "-"*44
      puts
    end

    desc "popular", "Tell you which gem is most required"
    option :directory, :type=>:string, :aliases=>'-d', :default=>File.dirname(__FILE__), :desc=>"The folder path to search Gemfile and .gemspec files(recursively)"
    def popular
      population = Population.new(options[:directory])
      ranking = population.dependencies.map {|item| item.gems}.flatten.inject(Hash.new(0)){|hash,a| hash[a]+=1; hash}

      puts "Which is the most popular gem?"
      puts "Here is the list of gems grouped by count of dependencies."
      puts "  " + "-"*77
      puts "  #   Dependent Gem"
      puts "  " + "-"*77
      ranking.inject({}) { |h,(k,v)| (h[v] ||= []) << k; h }.sort.reverse.each {|item| puts "  #{item[0]}   #{item[1].sort.join(', ')}" }
      puts "  " + "-"*77
      puts ""

    end

    desc "look_like", "Show a list of gems which are similar to a given gem"
    option :directory, :type=>:string, :aliases=>'-d', :default=>File.dirname(__FILE__), :desc=>"The folder path to search Gemfile and .gemspec files(recursively)"
    option :count, :type=>:numeric, :aliases=>'-c', :default=>10, :desc=>"Set item count to be shown"
    option :reverse, :type=>:boolean, :aliases=>'-r', :default=>false, :desc=>"Reverse sort"
    def look_like(something)
      sample = Dependency.new(get_folder_path(something))
      population = Population.new(options[:directory])
      result = population.compute_similarity_score(sample, options[:reverse])
      if result.count > 0 then
        result.each_with_index do |item, i|
          puts "#{item[0].ljust(30)}(#{item[1][:score].round(3)}pt)"
          exit if i > options[:count]
        end
      else
        puts "There are not similar one found like #{something} in the #{options[:directory]} directory."
      end
    end

    desc "suggest_for", "Show a list of gems which are suggested for a given gem"
    option :directory, :type=>:string, :aliases=>'-d', :default=>File.dirname(__FILE__), :desc=>"The folder path to search Gemfile and .gemspec files(recursively)"
    option :count, :type=>:numeric, :aliases=>'-c', :default=>10, :desc=>"Set item count to be shown"
    option :reverse, :type=>:boolean, :aliases=>'-r', :default=>false, :desc=>"Reverse sort"
    def suggest_for(something)
      sample = Dependency.new(get_folder_path(something))
      population = Population.new(options[:directory])
      result = population.compute_similarity_score(sample, options[:reverse])
      if result.count > 0 then
        suggestion = {}
        result = result.select{|key,item| item[:score]< 1.0 }
        result.each do |entry|
          (entry[1][:gems] - sample.gems).each do |gem|
            suggestion[gem]=0.0 if suggestion[gem].nil?
            suggestion[gem]+=entry[1][:score]
          end
        end
        if suggestion.count > 0 then
          options[:reverse] ? suggestion = suggestion.sort{|a,b| a[1] <=> b[1]} : suggestion = suggestion.sort{|a,b| b[1] <=> a[1]}
          suggestion.each_with_index do |item, i|
            puts "#{item[0].ljust(30)}(#{item[1].round(3)}pt)"
            exit if i > options[:count]
          end
        else
          puts "There are not recommendation for #{something} based on the dependencies found at #{options[:directory]} directory."
        end
      else
        puts "There are not similar one found like #{something} in the #{options[:directory]} directory."
      end
    end

    desc "also_required", "Show a list of gems a given gem is required by"
    def also_required(gem)
      # fake implementation
      print `find #{File.dirname(__FILE__)} | grep Gemfile$ | xargs grep "gem '#{gem}'" | sed 's/\\/Gemfile:gem.*//g' | sed 's/.*\\///g' | sed 's/:.*//g'`
    end

    desc "dependency", "Show a list of gems a given gem dependents on"
    def dependency(gem)
      # fake implementation
      print `find #{File.dirname(__FILE__)}/cache/gemfiles/#{gem[0]} | egrep "#{gem[0]}/#{gem}:.*/Gemfile" | xargs cat | sed "s/gem '//g" | sed "s/'//g"`
    end

    no_tasks do
      def get_folder_path(something)
        if File.exist?(something) then
          if something.match(/Gemfile\Z|\.gemspec\Z/) then
            base_path = `dirname #{something}`
          else
            base_path = something
          end
        else
          gem_with_version = `ls #{File.dirname(__FILE__)}/cache/gemfiles/#{something[0].downcase} | grep "^#{something}:"`.chomp
          if gem_with_version.size > 0 then
            base_path = "#{File.dirname(__FILE__)}/cache/gemfiles/#{gem_with_version[0]}/#{gem_with_version}"
          else
            puts "Gem name #{something} looks wrong. You need to provide collect gem name"
            exit
          end
        end
        base_path.chomp
      end

      def pluralize(count, name)
        if count > 1 then
          name  + "s"
        else
          name
        end
      end

    end
  end
end
