# language: ja
フィーチャ: イベントを管理する
  ユーザとして
  家計を管理したい
  それは「何に」、「いくら」お金を使ったのか管理するためだ

  シナリオ: 新しいイベントを登録する
    前提   "cuke"としてログインしている
    かつ   "新規イベント"ページを表示している
    ならば "新規"と表示されていること
    もし   以下の項目を入力する:
           | event_spent_on | 2010-02-22 |
           | event_title    | タイトル   |
           | event_note     | ノート     |
           | event_items_attributes_0_tag_list   | 食費 |
           | event_items_attributes_0_founds_in  | 1000 |
           | event_items_attributes_0_founds_out |    0 |
    かつ   "Save changes"ボタンをクリックする
    ならば "詳細"と表示されていること
    かつ   以下のテーブルが"table.event tr"に表示されていること:
           | 日付     | 2010-02-22 |
           | タイトル | タイトル    |
           | ノート   | ノート     |
    かつ   以下のテーブルが"table.items tr"に表示されていること:
           | タグ | 入金 | 出金 |
           | 食費 | 1000 | 0 |
    もし   "Back"リンクをクリックする
    ならば "一覧"と表示されていること
    もし   "Destroy"リンクをクリックする
    ならば "一覧"と表示されていること
    かつ   以下のテーブルが"table.reports tr"に表示されていること:
           | 日付       | タイトル |

