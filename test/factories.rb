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
    client
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
    sequence(:prompt) { |n| "THE_PROMPT_#{n}" }
    sequence(:model_mental_process) { |n| "MODEL_MENTAL_PROCESS_#{n}" }
  end

  factory :client do
    name { Faker::Name.unique.name }
    db_connection { "postgresql://localhost:5432/test" }
    api_key { "API_KEY" }
    default_model { "DEFAULT_MODEL" }
  end
end
