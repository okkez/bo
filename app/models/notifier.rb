class Notifier < ActionMailer::Base

  def success_notification(recipient, body)
     recipients recipient
     from       "bo+system@okkez.net"
     subject    "[bo] success notification"
     body(:message => body)
  end

  def failure_notification(recipient, body, exception)
     recipients recipient
     from       "bo+system@okkez.net"
     subject    "[bo] failure notification"
     body(:message => body, :exception => exception)
  end

end
