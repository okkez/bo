# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

def add_child_keyword(parent, child)
  case child
  when String
    parent.children.create(:name => child)
  when Array
    x = parent.children.create(:name => child.first)
    child.last.each do |w|
      add_child_keyword(x, w)
    end
  end
end

ActiveRecord::Base.transaction do
  user = User.create!(:nickname => 'nickname', :email => 'user@example.com')
  hashed_password = EmailCredential.create_hashed_password("monkey")
  e = user.email_credentials.build(:email            => user.email,
                                   :hashed_password  => hashed_password,
                                   :activation_token => "1"*20,
                                   :activated_at     => Time.now)
  e.save!

  10.times do |n|
    event = user.events.create!(:spent_on => (Date.today - n),
                                :user     => user,
                                :title    => "event #{n}",
                                :note     => "note " * 100)
    sum = 0
    5.times do |m|
      val = rand(10000) + 1000
      item1 = event.items.create!(:founds_in  => val)
      item1.tag_list = "食費"
      item1.save!
      sum += val
    end
    item2 = event.items.create!(:founds_out => sum)
    item2.tag_list = "現金"
    item2.save!
  end

  root = Keyword.create!(:name => "root")
  cost = root.children.create!(:name => "費用")
  [
   "その他", "オンラインサービス", "クリーニング", "ケーブルテレビ",
   "コンピュータ", "プロバイダ", "委託手数料", "衣料品", "医療費",
   "家賃", "教育", "銀行手数料",
   ["娯楽", ["ゲーム", "リクリエーション", "音楽", "映画", "旅行"]],
   "交通機関", ["公共料金", ["ガス", "ゴミ収集", "水道", "電気"]],
   "購読", ["自動車", ["ガソリン", "修理維持", "駐車場", "通行料"]],
   "趣味", "書籍", "消耗品", "食費",
   ["税金", ["その他の税", "健康保険", "公的年金", "国税", "地方税"]],
   "贈答", "調整", "電話料金", "日用品", ["勉強会", ["懇親会", "参加費"]],
   ["保険", ["賃貸住宅保険", "医療保険", "自動車保険", "生命保険"]],
   ["負債", ["クレジットカード"]]
  ].each do |w|
    add_child_keyword(cost, w)
  end
  assets = root.children.create!(:name => "資産")
  [
   ["投資", ["委託売買口座",
             ["オープンエンド型投資信託", "マーケット指標", "株式", "債権"]]],
   ["流動資産", ["現金", "当座預金", "普通預金"]],
   ["収益", ["その他の収入", "ボーナス", "給与", "贈与収入",
             ["利息収入", ["その他の利息", "当座預金利息", "普通預金利息"]]]],
   ["収入", ["配当収入", ["利息収入", ["債権利息"]]]],
   ["純資産", ["開始残高"]]
  ].each do |w|
    add_child_keyword(assets, w)
  end
end


