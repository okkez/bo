# -*- coding: utf-8 -*-

Factory.define :morning, :class => Item do |i|
  i.title "morning"
  i.spent_on Date.today
  i.note  'note'
  i.amount 300
  i.after_create{|item|
    item.tag_list = "食費, 朝食, 菓子パン"
    item.save
  }
end

Factory.define :lunch, :class => Item do |i|
  i.title "lunch"
  i.spent_on Date.today
  i.note  'note'
  i.amount 520
  i.after_create{|item|
    item.tag_list = "食費, 昼食, カツ丼"
    item.save!
  }
end

Factory.define :dinner, :class => Item do |i|
  i.title "dinner"
  i.spent_on Date.today
  i.note  'note'
  i.amount 950
  i.after_create{|item|
    item.tag_list = "食費, 夕食, ラーメン"
    item.save
  }
end
