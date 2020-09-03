FactoryBot.define do

  sequence(:test_email,11111) do |i|
    "abc#{i}@test.com"
  end

  factory :user do
    name  {"test"}
    email {generate :test_email}
    password {"password"}
    factory :admin_user do
      admin {true}
    end
  end

  factory :new_user, class: User do
    name  {"test2"}
    email {generate :test_email}
    password {"newpassword"}
  end

end
