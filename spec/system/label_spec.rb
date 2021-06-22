require 'rails_helper'
describe 'ラベルの登録・編集・検索機能のテスト', type: :system do


  let(:user) { FactoryBot.create(:user) }

  before do
    FactoryBot.create(:task, user: user)
    FactoryBot.create(:label)
    FactoryBot.create(:second_label)
    FactoryBot.create(:third_label)

  end

  def admin_login
    visit new_session_path
    fill_in 'session_email', with: 'default@gmail.com'
    fill_in 'session_password', with: 'asdf123'
    click_on 'ログイン'
  end


  describe 'ラベル機能のテスト' do
    context 'ラベルを選択してタスクを新規登録した場合' do
      it 'タスクの詳細画面に遷移する' do
        admin_login
        visit new_task_path
        fill_in 'task_title', with: 'task_title'
        fill_in 'task_content', with: 'task_content'
        select 2019, from: 'task_deadline_1i'
        select 5, from: 'task_deadline_2i'
        select 14, from: 'task_deadline_3i'
        select 22, from: 'task_deadline_4i'
        select "07", from: 'task_deadline_5i'
        select '未着手', from: 'task_status'
        select '高', from: 'task_priority'
        check 'ラベル1'
        click_on '登録する'
        expect(page).to have_content '登録が完了しました！'
        expect(page).to have_content 'task_title'
        expect(page).to have_content 'ラベル1'
      end
    end

    context 'タスクの編集画面でラベルを変更した場合' do
      it '一覧画面に遷移し表示されるラベルが編集される' do
        admin_login
        visit tasks_path
        all('tbody tr')[0].click_link '編集'
        check 'ラベル2'
        click_on '登録する'
        expect(page).to have_content '編集が完了しました！'
        expect(all('tbody tr')[0]).to have_content 'ラベル2'
      end
    end
    context 'ラベルで検索をした場合' do
      it '指定したラベルを持つタスクのみが表示される' do
        admin_login

        visit new_task_path
        fill_in 'task_title', with: 'task_title'
        fill_in 'task_content', with: 'task_content'
        select 2019, from: 'task_deadline_1i'
        select 5, from: 'task_deadline_2i'
        select 14, from: 'task_deadline_3i'
        select 22, from: 'task_deadline_4i'
        select "07", from: 'task_deadline_5i'
        select '未着手', from: 'task_status'
        select '高', from: 'task_priority'
        check 'ラベル1'
        click_on '登録する'

        visit new_task_path
        fill_in 'task_title', with: 'task_title'
        fill_in 'task_content', with: 'task_content'
        select 2019, from: 'task_deadline_1i'
        select 5, from: 'task_deadline_2i'
        select 14, from: 'task_deadline_3i'
        select 22, from: 'task_deadline_4i'
        select "07", from: 'task_deadline_5i'
        select '未着手', from: 'task_status'
        select '高', from: 'task_priority'
        check 'ラベル2'
        click_on '登録する'


        visit tasks_path
        select 'ラベル1', from: 'label_id'
        click_on '検索する'
        expect(all('tbody tr')[0]).to have_content 'ラベル1'
      end
    end
  end
end
