module DeviseHelper
  def localized_devise_error_messages!
    return "" if resource.errors.empty?

    if resource.errors.count <= 1
      sentence = t('activerecord.errors.template.header.one', :model => t("activemodel.models.#{resource_name}"))
    else
      sentence = t('activerecord.errors.template.header.other', :model => t("activemodel.models.#{resource_name}"), :count => resource.errors.count)
    end

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
    </div>
    HTML

    html.html_safe
  end
end
