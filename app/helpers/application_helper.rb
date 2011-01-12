# Commonly used view functions.
module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = t 'common.title_prefix'
    page_title = t @title
    separator  = t 'common.title_separator'
    "#{base_title}#{separator}#{page_title}"
  end
  
  # Gives each page a unique ID to provide CSS hooks.
  def body_id
    "#{controller_name}_#{action_name}"
  end
  
  # Returns the current locale to the view.
  def locale
    I18n.locale.to_s
  end

  def locale_as_int
    case locale
      when "en"
        0
      when "fr"
        1
      when "he"
        2
    end
  end

  # Returns true if the current locale should be mapped to a right-to-left view.
  def is_rtl_locale
    I18n.locale.to_s.eql?("he")
  end
  
end
