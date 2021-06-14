module RendererHelper
  include Pagy::Frontend

  def render_flashes(options = {})
    return if flash.blank?
    content_tag(:div, id: 'flashes') do
      output = flash.map do |k, v|
        next if v.blank?
        render_flash(k.to_sym, options) { content_tag(:p, v) }
      end
      output.compact.join("\n").html_safe
    end
  end

  def render_flash(type, options = {}, &block)
    renderer = FlashRenderer.new(self, type, options)
    renderer.content = capture(&block) if block_given?
    renderer.render
  end

  def obfuscate(string)
    if string.include?("@")
      string.split("@").map { |x| StringObfuscator.obfuscate(x, percent: 60, from: :right) }.join("@")
    else
      StringObfuscator.obfuscate(string, percent: 75)
    end
  end

end
