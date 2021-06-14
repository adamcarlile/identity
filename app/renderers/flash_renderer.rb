class FlashRenderer
  attr_accessor :options, :type
  attr_writer :content
  def initialize(controller, type, options = {})
    @controller = controller
    @type       = type
    @options    = options
  end

  def content
    @content ? @content : @controller.content_tag(:p, @controller.flash[type])
  end

  def content?
    !!content
  end

  def render
    return nil unless content?
    xhtml = Builder::XmlMarkup.new(indent: 2)
    xhtml.div flash_html_attributes do |div|
      div << content
    end
    xhtml.target!.html_safe
  end

  private

    def type_mapping
      @type_mapping ||= Hash.new('is-info').merge({
        alert: 'is-danger'
      })
    end

    def flash_html_attributes
      {
        id: options[:id],
        class: css_classes,
      }.reject { |_k, v| v.blank? }
    end

    def css_classes
      out = []
      out << 'notification'
      out << type_mapping[type]
      out << options[:class]
      out.compact.join(' ')
    end

end
