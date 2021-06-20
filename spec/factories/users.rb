FactoryBot.define do
  factory :user do
    name { 'デフォルトの名前' }
    email { 'default@gmail.com' }
    password { 'asdf123' }
    password_confirmation { 'asdf123' }
    admin { 'true' }
  end
  factory :second_user, class: User do
    name { 'デフォルトの名前2' }
    email { 'default2@gmail.com' }
    password { 'asdf123' }
    password_confirmation { 'asdf123' }
    admin { 'false' }
  end
end
