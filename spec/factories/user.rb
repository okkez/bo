
Factory.define :user do |u|
  u.nickname 'nickname'
  u.email 'nickname@example.com'
end

Factory.define :test, :parent => :user do |u|
  u.nickname 'test'
  u.email 'test@example.com'
  u.events{|event|
    [:morning, :lunch, :dinner].map{|label| event.association(label) }
  }
end

Factory.define :user_with_token, :parent => :user do |u|
  u.tokens{|token| [token.association(:mail_token)] }
end
