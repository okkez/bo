# -*- coding: utf-8 -*-

require 'mail_receiver'
require 'nkf'

module MailRegister

  class << self
    def run
      m = MailReceiver.new
      m.unseen(true) do |mail|
        entry(mail)
      end
    end

    def entry(mail)
      token = mail.to.first.gsub(/bo\+(.+?)@okkez\.net/){ $1 }
      token = Token.find_by_token_and_purpose(token, 'mail')
      user = token.try(:user)
      return unless user
      subject = NKF.nkf('-w', mail.subject)
      # TODO 入力文字コードをちゃんと設定する
      body = NKF.nkf('-w', Base64.decode64(mail.body))
      begin
        ActiveRecord::Base.transaction do
          event = user.events.create!(:spent_on => Date.today, :title => subject)
          sum = 0
          body.lines do |line|
            value, tags = line.split(' ', 2)
            next unless /\A[1-9][0-9]*\z/ =~ value
            item = event.items.create!(:founds_in => value.to_i)
            item.tag_list = tags
            item.save!
            sum += value.to_i
          end
          item = event.items.create!(:founds_out => sum)
          item.tag_list = "現金"
          item.save!
        end
        Notifier.deliver_success_notification(mail.from, body)
      rescue => ex
        # failed
        Rails.logger.info ex.inspect
        Rails.logger.info ex.backtrace.join("\n")
        Notifier.deliver_failure_notification(mail.from, body, ex)
      end
    end
  end
end
