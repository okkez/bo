
Factory.define :user do |u|
  u.name 'name'
  u.email 'name@example.com'
end

Factory.define :test, :parent => :user do |u|
  u.name 'test'
  u.email 'test@example.com'
  u.events{ [:morning, :lunch, :dinner].map{|label| Factory(label) } }
end

