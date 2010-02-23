# -*- coding: utf-8 -*-
Given /^"(.+?)"としてログインしている$/ do |user|
  @user = Factory(user)
  hashed_password = EmailCredential.create_hashed_password("monkey")
  @user.email_credentials.create!(:email            => @user.email,
                                  :hashed_password  => hashed_password,
                                  :activation_token => "1"*20,
                                  :activated_at     => Time.now)
  visit '/auth/email'
  fill_in('login_form_email', :with => "#{user}@example.com")
  fill_in('login_form_password', :with => 'monkey')
  click_button('Login')
end

Then /^以下のテーブルが"(.+?)"に表示されていること:$/ do |selector, expected|
  expected.diff!(tableish(selector, "th,td").to_a)
end
