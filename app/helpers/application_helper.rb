# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include MultiAuthHelper

  def google_jsapi_tag
    '<script type="text/javascript" src="http://www.google.com/jsapi"></script>'
  end

  def google_load_tag(name, version)
    %Q|<script type="text/javascript">google.load("#{name}", "#{version}");</script>|
  end

  def current_user
    @login_user if defined?(@login_user)
  end

end
