Factory.define :token do |m|
  m.user_id 1
  m.token "1"*20
  m.purpose 'token'
end

Factory.define :mail_token, :parent => :token do |m|
  m.token "2"*20
  m.purpose 'mail'
end

