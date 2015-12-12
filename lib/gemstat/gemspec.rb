module Gemstat
  class Gemspec
    attr_reader :gems
    def initialize(filepath)
      @gems=[]
      File.open(filepath).read.each_line {|line|
        line.strip!
        if line[0]!='#' && line.match(/add_.*dependency '(.*?)'/) then
          @gems.push Regexp.last_match[1]
        end
      }
    end
  end
end
