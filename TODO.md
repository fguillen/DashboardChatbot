- Add has_many form: https://learn.co/lessons/has-many-through-forms-rails
- Implement "login as (front user)" in admin menu
- Posts controller only allow the creator to access to its own Posts
- move Controller Tests to ActionDispatch::IntegrationTest (it is done in front_articles_controller_test)
- Upgrade ruby 3.2.4 and set docker image to FROM ruby:3.2.4-alpine3.19
- move credentials to Rails credentials (https://edgeguides.rubyonrails.org/security.html#custom-credentials)

- When looking for UserFavorites::Neighbors we have to filter for FrontUser
