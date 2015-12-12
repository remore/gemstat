module Gemstat
  class Population
    attr_reader :dependencies
    def initialize(folder_path)
      cache_path = File.dirname(__FILE__) + '/cache/' + `du -s #{File.dirname(__FILE__)}/cache/gemfiles | cut -f1`.chomp + '.cache'
      if File.exist?(cache_path) then
        @dependencies = Marshal.load(File.read(cache_path))
      else
        @dependencies = []
        `find #{folder_path} -type d`.each_line do |line|
          dependency = Dependency.new(line.chomp)
          @dependencies.push dependency if dependency.exist?
        end
        File.open(cache_path, 'w') {|f| f.write(Marshal.dump(@dependencies)) }
      end
    end

    def compute_similarity_score(sample, reversed = false)
      result = {}
      @dependencies.each do |item|
        score = 1.0 / (1.0+((sample.gems + item.gems) - (sample.gems & item.gems)).uniq.count)
        if score > 1.0/(1.0+sample.gems.count) then
          result[item.gem_name] = {:score => score, :gems => item.gems}
        end
      end
      reversed ? result = result.sort{|a,b| a[1][:score] <=> b[1][:score]} : result = result.sort{|a,b| b[1][:score] <=> a[1][:score]}
    end
  end
end
