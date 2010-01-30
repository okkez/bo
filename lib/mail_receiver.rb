# -*- coding: utf-8 -*-
require 'net/imap'
require 'tmail'

class MailReceiver

  def initialize
    @smtp_settings = YAML.load_file(Rails.root + 'config/smtp.yml')
    @user = @smtp_settings[:user_name]
    @password = @smtp_settings[:password]
    @imap = Net::IMAP.new('imap.gmail.com', 993, true)
    @imap.login(@user, @password)
    @imap.select("INBOX")
  end

  def all(&block)
    ids = @imap.search(["ALL"])
    fetch(ids, &block)
    nil
  end

  def unseen(store = true, &block)
    ids = @imap.search(["UNSEEN"])
    fetch(ids, &block)
    return if ids.empty?
    @imap.store(ids, "+FLAGS", [:Seen]) if store
    nil
  end

  def seen(&block)
    ids = @imap.search(["SEEN"])
    fetch(ids, &block)
    nil
  end

  private

  def fetch(ids)
    return if ids.empty?
    @imap.fetch(ids, ["RFC822"]).each do |mail|
      yield TMail::Mail.parse(mail.attr["RFC822"])
    end
  end

end
