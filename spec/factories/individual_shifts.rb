FactoryBot.define do
  factory :individual_shift do
    start { "2021-03-06 15:48:15" }
    finish { "2021-03-06 15:48:15" }
    Temporary { false }
    deletable { false }
    mode { "MyString" }
    plan { "MyString" }
    staff { nil }
  end
end
