FactoryBot.define do
  factory :master do
    store_name { "" }
    user_name { "" }
    password_digest { "" }
    remember_digest { "" }
    shift_onoff { "" }
    staff_number { "" }
    email { "" }
    onoff_email { false }
  end
end
