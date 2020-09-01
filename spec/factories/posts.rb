# coding: utf-8
FactoryBot.define do

  factory :post do
    title   {"test1"}
    content {"test1"}
    code    {"test1"}
    user_id {"1"}
  end

  factory :new_post, class: Post do
    title   {"test2"}
    content {"test2"}
    code    {"test2"}
    user_id {"2"}
  end

end

