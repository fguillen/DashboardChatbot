FactoryBot.define do
  factory :admin_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { "Pass$$$!" }
  end

  factory :admin_authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    admin_user
  end

  factory :front_authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    front_user
  end

  factory :front_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { "Pass$$$!" }
  end

  factory :article do
    title { Faker::Lorem.sentence(word_count: 20) }
    body { Faker::Lorem.sentence(word_count: 20) }
    front_user
  end

  factory :conversation do
    title { Faker::Lorem.sentence(word_count: 4) }
    front_user
  end

  factory :message do
    role { Message.roles[:user] }
    conversation
  end

  factory :log_book_event, :class => LogBook::Event  do
    differences { "Wadus Event" }
    association :historizable, factory: :article
  end

  factory :alert do
    front_user
    schedule { "*/5 * * * *" }
    name { Faker::Lorem.sentence(word_count: 3) }
    prompt { Faker::Lorem.sentence(word_count: 8) }
    context { Faker::Lorem.sentence(word_count: 8) }
  end

  factory :alert_email do
    alert
    subject { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.sentence(word_count: 8) }
    from { Faker::Internet.email }
    to { Faker::Internet.email }
  end

  factory :user_reaction do
    message
    kind { UserReaction.kinds[:positive] }
  end

  factory :user_favorite do
    user_reaction
    prompt { "The prompt" }
    model_mental_process { "The model mental process" }
  end
end
