module MarkdownHelper
  def markdown(text)
    return "" if text.blank?
    
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      link_attributes: { target: "_blank", rel: "noopener" }
    )
    
    extensions = {
      autolink: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
      superscript: true,
      highlight: true,
      no_intra_emphasis: true,
      lax_spacing: true,
      space_after_headers: true
    }
    
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end
end
