FactoryBot.define do
  factory :staff do
    staff_name { "MyString" }
    staff_number { 1 }
    training_mode { false }
    password_digest { "MyString" }
    master { nil }
  end
end
