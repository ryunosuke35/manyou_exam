### モデル名 Task

| カラム名 | データ型 |
| :---: | :---: |
| title | string |
| content | text |
| task_deadline | datetime |
| status | integer |
| priority | integer |


### モデル名 User

| カラム名 | データ型 |
| :---: | :---: |
| name | string |
| email | string |
| password_digest | text |



### デプロイの方法
git add .  
git commit -m "[変更内容を記述]"  
git push heroku master  






### 使用gem
gem 'rails', '5.2.5'  
gem 'pg', '>= 0.18', '< 2.0'  
gem 'puma', '~> 3.11'  
gem 'sass-rails', '~> 5.0'  
gem 'uglifier', '>= 1.3.0'  
gem 'coffee-rails', '~> 4.2'  
gem 'turbolinks', '~> 5'  
gem 'jbuilder', '~> 2.5'  
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do  
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]  
  gem 'rspec-rails', '~> 3.8'  
  gem 'factory_bot_rails'  
end

group :development do  
&nbsp; gem 'web-console', '>= 3.3.0'  
  gem 'listen', '>= 3.0.5', '< 3.2'  
  gem 'spring'  
  gem 'spring-watcher-listen', '~> 2.0.0'  
  gem 'pry-rails'  
  gem 'pry-byebug'  
  gem 'meta_request'  
  gem 'better_errors'  
  gem 'binding_of_caller'  
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
