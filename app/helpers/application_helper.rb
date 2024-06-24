module ApplicationHelper
  def bootstrap_alert_class(type)
    case type
    when :alert
      "alert alert-danger"
    when :notice
      "alert alert-success"
    else
      type.to_s
    end
  end

  def render_label(word, palette_name)
    StylePalette::Helper.label(h(word), palette_name).html_safe
  end

  def render_labels(words, palette_name)
    words.map { |e| render_label e, palette_name }.join(" ").html_safe
  end

  def markdown(text)
    return "" if text.blank?
    MarkdownRenderer.render(text).html_safe
  end
end
