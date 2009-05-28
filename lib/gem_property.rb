class GemProperty
  UNSUPPORTED_DEPENDENCIES = %w{ rubyinline }
  
  def self.set(code)
    raise(ArgumentError, "Must provide an instance of Code") unless code.is_a?(Code)
    g = GemProperty.new(code.slug_name)
    p = g.properties
    code.c_extension = p[:contains_c_extension]
    
    (p[:dependencies] || []).each do |d|
      code.dependencies << Dependency.new(:gem=>d)
    end
    
    code
  end
  
  attr_reader :gem, :file, :path
  
  def initialize(gem_name)
    @gem = gem_name
    @path = "/tmp/GemProperty-#{rand(1000000)}"
    init_path(@path)
  end
  
  
  def properties
    init_path(@path)
    output = {}
    
    Dir.chdir(@path) do
      download_gem
      extract_gem
      
      output = {
        :contains_c_extension     => contains_c_extension?,
        :dependencies             => dependencies
      }
    end

    return output
  ensure
    clean_up(@path)
  end
  
  # private
    def init_path(path)
      clean_up(path)
      `mkdir -p #{path}`
    end
  
    def clean_up(path)
      `rm -fr #{path}`
    end
  
    def download_gem
      output = `gem fetch #{@gem}`

      if output.match(/^Downloaded /)
        @file = output.split(" ")[1]
        return @file
      else
        raise "Could not download #{@gem}: #{output}"
      end
    end

    def extract_gem
      `tar xvf #{@path}/#{@file}.gem 2>/dev/null`
      `gunzip #{@path}/metadata.gz 2>/dev/null`
    end
    
    def gem_specs
      @gem_specs ||= YAML.load_file("#{path}/metadata")
    end
    
    def files
      gem_specs.files
    end
    
    def contains_c_extension?
      files.each do |f|
        return true if f.match(/\.h$|\.cpp$|\.c$/)
      end
      false
    end

    def dependencies
      output = []
      gem_specs.dependencies.each do |d|
        output << d.name
      end
      output
    end
end