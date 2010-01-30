Factory.define :token do |m|
  m.user_id 1
  m.token "1"*20
  m.purpose 'mail'
end

