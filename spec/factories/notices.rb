FactoryBot.define do
  factory :notice do
    mode { "MyString" }
    shift_id { 1 }
    staff_id { 1 }
    comment { "MyString" }
    master { nil }
  end
end
