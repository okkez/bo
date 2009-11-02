# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def google_jsapi_tag
    '<script type="text/javascript" src="http://www.google.com/jsapi"></script>'
  end

  def google_load_tag(name, version)
    '<script type="text/javascript">google.load("#{name}", "#{version}");</script>'
  end
end
