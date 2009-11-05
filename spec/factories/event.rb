
Factory.define :event do |e|
  e.user_id 0
  e.spent_on Date.today
  e.title "morning"
  e.note "note"
end

[:morning, :lunch, :dinner].each do |label|
  Factory.define label, :parent => :event do |e|
    e.title label.to_s
    e.items{ [Factory("#{label}_meal".to_sym), Factory("#{label}_money".to_sym)] }
  end
  Factory.define "#{label}_1_years_ago".to_sym, :parent => :event do |e|
    e.spent_on 1.years.ago
    e.title label.to_s
    e.items{ [Factory("#{label}_meal".to_sym), Factory("#{label}_money".to_sym)] }
  end
  Factory.define "#{label}_recent_n_months", :parent => :event do |e|
    case label
    when :morning then e.spent_on 3.month.ago
    when :lunch   then e.spent_on 2.month.ago
    when :dinner  then e.spent_on 1.month.ago
    end
    e.title label.to_s
    e.items{ [Factory("#{label}_meal".to_sym), Factory("#{label}_money".to_sym)] }
  end
end

