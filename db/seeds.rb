# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

ActiveRecord::Base.transaction do
  user = User.create!(:nickname => 'nickname', :email => 'user@example.com')
  hashed_password = EmailCredential.create_hashed_password("monkey")
  e = user.email_credentials.build(:email            => user.email,
                                   :hashed_password  => hashed_password,
                                   :activation_token => "1"*20,
                                   :activated_at     => Time.now)
  e.save!

  10.times do |n|
    event = user.events.create!(:spent_on => (Date.today - n),
                                :user     => user,
                                :title    => "event #{n}",
                                :note     => "note" * 100)
    5.times do |m|
      val = rand(10000) + 1000
      item1 = event.items.create!(:founds_in  => val)
      item1.tag_list = "食費"
      item1.save!
      item2 = event.items.create!(:founds_out => val)
      item2.tag_list = "現金"
      item2.save!
    end
  end

end
