password = "p4sswORd"
email = "admin@example.com"

unless AdminUser.where(email: email).exists?
  AdminUser.create!(
    name: "Admin User",
    email: email,
    password: password,
    password_confirmation: password
  )
  puts "AdminUser created #{email}/#{password}"
end

client_name = "Client Test"

unless Client.where(name: client_name).exists?
  Client.create!(
    name: client_name,
    db_connection: "postgresql://localhost:5432/test",
    api_key: "API_KEY",
    default_model: "DEFAULT_MODEL",
  )
  puts "Client created #{client_name}"
end

password = "p4sswORd"
email = "front@example.com"

unless FrontUser.where(email: email).exists?
  FrontUser.create!(
    client: Client.find_by(name: client_name),
    name: "Front User",
    email: email,
    password: password,
    password_confirmation: password
  )
  puts "FrontUser created #{email}/#{password}"
end



# tags_example = ["shopping", "cooking", "hang-out", "love", "passion"]
# 10.times do
#   article =
#     Article.create!(
#       front_user: FrontUser.find_by(email: email),
#       title: Faker::Lorem.sentence,
#       body: Faker::Lorem.paragraphs(number: rand(10..20)).join("\n\n"),
#       tag_list: tags_example.sample(rand(0..3))
#     )
#   article.pic.attach(io: File.open("#{Rails.root}/test/fixtures/files/yourule.png"), filename: "yourule.png")

#   puts "Article created: '#{article.title}'"
# end
