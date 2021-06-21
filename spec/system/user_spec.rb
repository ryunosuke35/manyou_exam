require 'rails_helper'
describe 'ユーザ登録・セッション機能・管理画面のテスト', type: :system do

  before do
    FactoryBot.create(:user)
    FactoryBot.create(:second_user)
  end

  def admin_login
    visit new_session_path
    fill_in 'session_email', with: 'default@gmail.com'
    fill_in 'session_password', with: 'asdf123'
    click_on 'ログイン'
  end

  def general_login
    visit new_session_path
    fill_in 'session_email', with: 'default2@gmail.com'
    fill_in 'session_password', with: 'asdf123'
    click_on 'ログイン'
  end


  describe 'ユーザ登録のテスト' do
    context 'ユーザを新規登録した場合' do
      it '作成したタスク・終了期限・ステータスが表示される' do
        visit new_user_path
        fill_in 'user_name', with: '松村龍之介'
        fill_in 'user_email', with: 'matsumura@gmail.com'
        fill_in 'user_password', with: 'asdf123'
        fill_in 'user_password_confirmation', with: 'asdf123'
        click_on '登録する'
        expect(page).to have_content '松村龍之介'
        expect(page).to have_content 'matsumura@gmail.com'
      end
    end
    context 'ユーザがログインせずタスク一覧画面にとぼうとした場合' do
      it 'ログイン画面に遷移する' do
        visit tasks_path
        expect(page).to have_content 'ログイン'
      end
    end
  end


  describe 'セッション機能のテスト' do
    context 'ログイン操作をした場合' do
      it 'ログインできる' do
        admin_login
      end
    end
    context 'ログインした場合' do
      it '自分の詳細画面(マイページ)にとぶ' do
        admin_login
        expect(page).to have_content 'デフォルトの名前'
        expect(page).to have_content 'efault@gmail.com'
      end
    end
    context '一般ユーザが他人の詳細画面にとんだ場合' do
      it '自分のタスク一覧画面に遷移する' do
        general_login
        user_id = User.ids[0]
        visit user_path(user_id)
        expect(page).to have_content '一覧'
      end
    end
    context 'ログアウトした場合' do
      it '自分の詳細画面(マイページ)にとぶ' do
        admin_login
        click_link 'Logout'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end


  describe '管理画面のテスト' do
    context '管理ユーザが管理画面にアクセスした場合' do
      it '管理画面のユーザー一覧画面へとぶ' do
        admin_login
        visit admin_users_path
        expect(page).to have_content '管理画面のユーザー一覧'
      end
    end
    context '一般ユーザが管理画面にアクセスした場合' do
      it 'タスク一覧画面へとぶ' do
        general_login
        visit admin_users_path
        expect(page).to have_content '管理者権限がありません！'
        expect(page).to have_content '一覧'
      end
    end
    context '管理ユーザがユーザの新規登録をした場合' do
      it '一覧画面にとび、登録者の名前とメールアドレスが表示される' do
        admin_login
        visit admin_users_path
        click_link '新規登録'
        fill_in 'user_name', with: '松村龍之介'
        fill_in 'user_email', with: 'matsumura@gmail.com'
        fill_in 'user_password', with: 'asdf123'
        fill_in 'user_password_confirmation', with: 'asdf123'
        select '一般', from: 'user_admin'
        click_on 'アカウントを作成する'
        expect(page).to have_content '松村龍之介'
        expect(page).to have_content 'matsumura@gmail.com'
        expect(page).to have_content 'false'
      end
    end
    context '管理ユーザがユーザの詳細画面したにアクセスした場合' do
      it 'ユーザの情報と、そのユーザのタスク一覧が表示される' do
        admin_login
        visit admin_users_path
        all('tbody tr')[1].click_link '詳細'
        expect(page).to have_content 'デフォルトの名前2'
        expect(page).to have_content 'default2@gmail.com'
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '内容'
        expect(page).to have_content '終了期限'
        expect(page).to have_content 'ステータス'
        expect(page).to have_content '優先順位'
      end
    end
    context '管理ユーザがユーザの情報を編集するリンクをクリックした場合' do
      it '管理者一覧画面にとび、情報が編集される' do
        admin_login
        visit admin_users_path
        all('tbody tr')[1].click_link '編集'
        fill_in 'user_name', with: 'デフォルトの名前3'
        fill_in 'user_email', with: 'matsumura3@gmail.com'
        fill_in 'user_password', with: 'asdf1234'
        fill_in 'user_password_confirmation', with: 'asdf1234'
        select '管理者', from: 'user_admin'
        click_on '変更'
        expect(page).to have_content 'デフォルトの名前3'
        expect(page).to have_content 'matsumura3@gmail.com'
      end
    end
    context '管理ユーザがユーザの情報を削除するリンクをクリックした場合' do
      it '管理者一覧画面にとび、情報が削除される' do
        admin_login
        visit admin_users_path
        all('tbody tr')[1].click_link '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).not_to have_content 'デフォルトの名前2'
        expect(page).not_to have_content 'default2@gmail.com'
      end
    end
  end

end
