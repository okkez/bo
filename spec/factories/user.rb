
Factory.define :user do |u|
  u.nickname 'nickname'
  u.email 'nickname@example.com'
end

Factory.define :test, :parent => :user do |u|
  u.nickname 'test'
  u.email 'test@example.com'
  u.events{ [:morning, :lunch, :dinner].map{|label| Factory(label) } }
end

