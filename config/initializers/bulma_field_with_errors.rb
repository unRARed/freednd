ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')
  model = instance_tag.object
  error_message = model.errors.full_messages.join(', ')
  html = if field
    field['class'] = "#{field['class']} is-danger"
    html = <<-HTML
      #{fragment.to_s}
      <span class="tag is-danger is-light mt2">
        #{error_message}
      </span>
    HTML
    html
  else
    html_tag
  end
  html.html_safe
end
