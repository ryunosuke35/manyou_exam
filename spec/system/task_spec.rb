require 'rails_helper'
describe 'タスク管理機能', type: :system do

  let(:user) { FactoryBot.create(:user) }

  before do
    FactoryBot.create(:task, user: user)
    FactoryBot.create(:second_task, user: user)
  end

  def test_login
    visit new_session_path
    fill_in 'session_email', with: 'default@gmail.com'
    fill_in 'session_password', with: 'asdf123'
    click_on 'ログイン'
  end


  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        task = FactoryBot.create(:task, title: 'task', user: user)
        test_login
        visit tasks_path
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task = FactoryBot.create(:task, title: 'task', content: 'task_content', user: user)
        test_login
        visit tasks_path
        expect(all('tbody tr')[0]).to have_content 'task'
        expect(all('tbody tr')[0]).to have_content 'task_content'
      end
    end
    context '終了期限でソートするリンクを押した場合' do
      it '期限の近いタスクが一番上に表示される' do
        task = FactoryBot.create(:task, deadline: '2019-06-14 22:07:00', user: user)
        test_login
        visit tasks_path
        click_link '終了期限'
        sleep 1
        expect(all('tbody tr')[0]).to have_content '2019-05-14 22:07:00'
      end
    end
    context '優先順位でソートするリンクを押した場合' do
      it '優先順位の高いタスクが一番上に表示される' do
        task = FactoryBot.create(:task, priority: '中', user: user)
        test_login
        visit tasks_path
        click_link '優先順位'
        sleep 1
        expect(all('tbody tr')[0]).to have_content '高'
      end
    end
    context 'タイトルであいまい検索をした場合' do
      it '検索した内容を含むタスクが表示される' do
        task = FactoryBot.create(:task, title: '洗濯をする', user: user)
        test_login
        visit tasks_path
        fill_in 'ambiguous', with: '洗濯'
        click_on '検索する'
        expect(page).to have_content '洗濯'
        expect(page).not_to have_content 'Factoryで作ったデフォルトのタイトル'
      end
    end
    context 'ステータスで検索した場合' do
      it '検索したステータスを含むタスクが表示される' do
        task = FactoryBot.create(:task, status: '未着手', user: user)
        test_login
        visit tasks_path
        select '未着手', from: 'status'
        click_on '検索する'
        expect(all('tbody tr')[0]).to have_content '未着手'
      end
    end
    context 'タイトルとステータスの両方で検索した場合' do
      it 'タイトルとステータスの両方を含むタスクが表示される' do
        task = FactoryBot.create(:task, title: '洗濯をする', status: '完了', user: user)
        task = FactoryBot.create(:task, title: '洗濯物を干す', status: '未着手', user: user)
        test_login
        visit tasks_path
        fill_in 'ambiguous', with: '洗濯'
        select '未着手', from: 'status'
        click_on '検索する'
        expect(page).to have_content '洗濯物を干す'
        expect(page).to have_content '未着手'
        expect(all('tbody tr')[0]).not_to have_content '完了'
        expect(all('tbody tr')[0]).not_to have_content '着手中'
      end
    end
  end


  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスク・終了期限・ステータスが表示される' do
        test_login
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
        click_on '登録する'
        visit tasks_path
        expect(page).to have_content 'task_title'
        expect(page).to have_content 'task_content'
        expect(page).to have_content '2019-05-14 22:07:00'
        expect(page).to have_content '未着手'
        expect(page).to have_content '中'
      end
    end
  end


  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        test_login
        task = FactoryBot.create(:task, title: 'task' ,content: 'task_content', user: user)
        visit task_path(task.id)
        expect(page).to have_content 'task'
        expect(page).to have_content 'task_content'
      end
    end
  end
end
