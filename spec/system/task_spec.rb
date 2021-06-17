require 'rails_helper'
describe 'タスク管理機能', type: :system do

  before do
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
  end


  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        task = FactoryBot.create(:task, title: 'task')
        visit tasks_path
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task = FactoryBot.create(:task, title: 'task', content: 'task_content')
        visit tasks_path
        expect(all('tbody tr')[0]).to have_content 'task'
        expect(all('tbody tr')[0]).to have_content 'task_content'
      end
    end
    context '終了期限でソートするリンクを押した場合' do
      it '期限の近いタスクが一番上に表示される' do
        task = FactoryBot.create(:task, deadline: '2019-06-14 22:07:00 +0900')
        visit tasks_path
        click_link '終了期限でソートする'
        sleep 1
        expect(all('tbody tr')[0]).to have_content '2019-05-14 22:07:00 +0900'
      end
    end
    context 'タイトルであいまい検索をした場合' do
      it '検索した内容を含むタスクが表示される' do
        task = FactoryBot.create(:task, title: '洗濯をする')
        visit tasks_path
        fill_in 'ambiguous', with: '洗濯'
        click_on '検索する'
        expect(page).to have_content '洗濯'
        expect(page).not_to have_content 'Factoryで作ったデフォルトのタイトル'
      end
    end
    context 'ステータスで検索した場合' do
      it '検索したステータスを含むタスクが表示される' do
        task = FactoryBot.create(:task, priority: '未着手')
        visit tasks_path
        select '未着手', from: 'priority'
        click_on '検索する'
        expect(all('tbody tr')[0]).to have_content '未着手'
      end
    end
    context 'タイトルとステータスの両方で検索した場合' do
      it 'タイトルとステータスの両方を含むタスクが表示される' do
        task = FactoryBot.create(:task, title: '洗濯をする', priority: '完了')
        task = FactoryBot.create(:task, title: '洗濯物を干す', priority: '未着手')
        visit tasks_path
        fill_in 'ambiguous', with: '洗濯'
        select '未着手', from: 'priority'
        click_on '検索する'
        expect(page).not_to have_content 'Factoryで作ったデフォルトのタイトル'
        expect(all('tbody tr')[0]).not_to have_content '完了'
        expect(all('tbody tr')[0]).not_to have_content '着手中'
      end
    end
  end


  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスク・終了期限・ステータスが表示される' do
        visit new_task_path
        fill_in 'task_title', with: 'task_title'
        fill_in 'task_content', with: 'task_content'
        select 2019, from: 'task_deadline_1i'
        select 5, from: 'task_deadline_2i'
        select 14, from: 'task_deadline_3i'
        select 22, from: 'task_deadline_4i'
        select "07", from: 'task_deadline_5i'
        select '未着手', from: 'task_priority'

        click_on '登録する'
        visit tasks_path

        expect(page).to have_content 'task_title'
        expect(page).to have_content 'task_content'
        expect(page).to have_content '2019-05-14 22:07:00'
        expect(page).to have_content '未着手'
      end
    end
  end


  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
      task = FactoryBot.create(:task, title: 'task' ,content: 'task_content')
      visit task_path(task.id)
      expect(page).to have_content 'task'
      expect(page).to have_content 'task_content'
      end
    end
  end

end
