# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'

# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  background do
  # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
  @task1=FactoryBot.create(:task)
  @task2=FactoryBot.create(:second_task)
  end

  scenario "タスク一覧のテスト" do
  # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path
  # タスク一覧ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
    expect(page).to have_content 'factory_name_1'
    expect(page).to have_content 'factory_詳細1'
  end

  scenario "タスク作成のテスト" do
  # new_task_pathにvisitする（タスク登録ページに遷移する）
    visit new_task_path
  # タスクのタイトルと内容をそれぞれfill_in（入力）する
    fill_in 'タスク名',with:'work'
    fill_in '詳細',with:'practice'

  #「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
    click_on '登録する'

  # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
  # タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
    expect(page).to have_content 'work' 
    expect(page).to have_content 'practice'
  end

  scenario "タスク詳細のテスト" do
  # タスク詳細ページに遷移
    visit task_path(@task1)
  # タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
    expect(page).to have_content 'factory_name_1'
    expect(page).to have_content 'factory_詳細1'
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
  #タスクが作成日時の降順に並んでいる
  expect(Task.order("updated_at DESC").map(&:id))
  end

  scenario "タスクが終了期限の降順に並んでいるかのテスト" do
  visit tasks_path(sort_expired: "true")
  #タスクが終了期限の降順に並んでいる
  expect(Task.order("deadline DESC").map(&:id))
  end
end