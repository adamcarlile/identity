class Template
  class << self

    def all
      available_templates
    end
    
    def find(name)
      available_templates[name.to_sym]
    end

    private

    def template_path
      Dir[File.join(Rails.root, 'app', 'views', 'templates', '*')]
    end

    def available_templates
      @available_templates ||= template_path.map do |x| 
        template = new(x)
        [template.name, template]
      end.to_h
    end
  end

  def initialize(path)
    @path = path
  end
  attr_reader :path
  
  def name
    @name ||= path.split('/').last.to_sym
  end

  def to_s
    name.to_s.humanize.capitalize
  end
end