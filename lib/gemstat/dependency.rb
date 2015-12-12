module Gemstat
  class Dependency
    attr_reader :gems, :name
    def initialize(folder_path)
      ENV["BUNDLE_GEMFILE"] = "./Gemfile" # set this otherwise you'll get the error: `rescue in root': Could not locate Gemfile or .bundle/ directory (Bundler::GemfileNotFound)
      @gems = []
      if File.exist?("#{folder_path}/Gemfile") then
        @gemfile = "#{folder_path}/Gemfile"
        definition = Bundler::Definition.build @gemfile, nil, nil
        @gems = @gems + definition.dependencies.map{|dependency| dependency.name}
      end
      gemspec_path = Dir.entries(folder_path).select{|name| name.match(/(.*).gemspec\Z/)}[0]
      if gemspec_path then
        @gemspec = folder_path+"/"+gemspec_path
        #@gems = @gems + Gem::Specification.load(@gemspec).dependencies.map{|dependency| dependency.name}
        @gems = Gemspec.new(@gemspec).gems
        @name = gemspec_path.match(/(.*).gemspec\Z/)[1]
      end
      @name = @name || `basename #{folder_path}`.chomp
    end

    def exist?
      !@gemfile.nil? || !@gemspec.nil?
    end

    def gem_name
      if @name.index(':')
        @name.match(/(.*):(.*)/)[1]
      else
        @name
      end
    end

    def gem_version
      if @name.index(':')
        @name.match(/(.*):(.*)/)[2]
      else
        @name
      end
    end
  end
end
