# -*- coding: utf-8 -*-

require 'mail_receiver'
require 'nkf'

module MailRegister

  class << self
    def run
      m = MailRegister.new
      m.unseen(true) do |mail|
        entry(mail)
      end
    end

    def entry(mail)
      token = mail.to.first.gsub(/bo\+(.+?)@okkez\.net/){ $1 }
      user = Token.find_by_token_and_purpose(token, 'mail').user
      return unless user
      subject = NKF.nkf('-w', Base64.decode64(mail.subject))
      body = NKF.nkf('-w', Base64.decode64(mail.body))
      begin
        ActiveRecord::Base.transaction do
          event = user.events.create!(:spent_on => Date.today, :title => subject)
          body.lines do |line|
            value, tags = line.split(' ', 2)
            next unless /\A[1-9][0-9]*\z/ =~ value
            item = event.items.create!(:founds_in => value.to_i)
            item.tag_list = tags
            item.save!
          end
          item = event.items.create!(:founds_out => sum)
          item.tag_list = "現金"
          item.save!
        end
      rescue
        # failed
      end
    end
  end
end
