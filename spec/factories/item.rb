# -*- coding: utf-8 -*-

Factory.define :morning_meal, :class => Item do |i|
  i.founds_in 300
  i.after_create{|item|
    item.tag_list = "食費 朝食 菓子パン"
    item.save
  }
end

Factory.define :morning_money, :class => Item do |i|
  i.founds_out 300
  i.after_create{|item|
    item.tag_list = "現金"
    item.save
  }
end

Factory.define :lunch_meal, :class => Item do |i|
  i.founds_in 520
  i.after_create{|item|
    item.tag_list = "食費 昼食 カツ丼"
    item.save!
  }
end

Factory.define :lunch_money, :class => Item do |i|
  i.founds_out 520
  i.after_create{|item|
    item.tag_list = "現金"
    item.save!
  }
end

Factory.define :dinner_meal, :class => Item do |i|
  i.founds_in 950
  i.after_create{|item|
    item.tag_list = "食費 夕食 ラーメン"
    item.save
  }
end

Factory.define :dinner_money, :class => Item do |i|
  i.founds_out 950
  i.after_create{|item|
    item.tag_list = "現金"
    item.save
  }
end

