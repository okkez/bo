Factory.define :token do |m|
  m.token "1"*20
  m.purpose 'token'
end

Factory.define :mail_token, :parent => :token do |m|
  m.token "2"*20
  m.purpose 'mail'
end

Factory.define :api_token, :parent => :token do |m|
  m.token{ Token.generate }
  m.purpose "API"
end
