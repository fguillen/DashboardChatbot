module ApplicationHelper
  def bootstrap_alert_class(type)
    case type
    when :alert
      "alert bg-danger-subtle text-danger-emphasis"
    when :notice
      "alert bg-success-subtle text-success-emphasis"
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

  def message_content(message)
    content_language = message.content_language
    if content_language == "markdown"
      markdown(message.content)
    elsif content_language == "chart_line"
      line_chart(SafeRuby.eval(message.content.gsub("null", "nil")))
    elsif content_language == "chart_column"
      column_chart(SafeRuby.eval(message.content.gsub("null", "nil")))
    else
      result = <<~HTML.html_safe
        <pre><code
          class="language-#{content_language}"
        >#{message.content_parsed}</code></pre>
      HTML

      result
    end
  end

  def formatted_date_or_empty(date)
    if date.present?
      l(date, format: :short)
    else
      "-"
    end
  end

  def message_card_classes_by_role(role)
    case role
    when "user"
      "text-white bg-info"
    when "assistant"
      "border border-light"
    when "system"
      "border border-warning"
    when "tool"
      "border border-warning"
    else
      Rails.logger.error("unknown role: #{role}")
    end
  end
end
