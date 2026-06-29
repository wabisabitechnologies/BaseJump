FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Company #{n}" }
  end

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    company

    trait :admin do
      admin { true }
    end

    trait :owner do
      owner { true }
    end
  end

  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { Faker::Lorem.sentence }
    project_type { 'project' }
    company
    association :admin, factory: :user

    trait :company_hq do
      project_type { 'company' }
      name { 'Company HQ' }
    end

    trait :team do
      project_type { 'team' }
    end

    trait :with_template do
      is_template { true }
    end
  end

  factory :user_project do
    user
    project
  end

  factory :todo_list do
    sequence(:title) { |n| "Todo List #{n}" }
    description { Faker::Lorem.sentence }
    project
    association :author, factory: :user
  end

  factory :todo do
    sequence(:title) { |n| "Todo #{n}" }
    description { Faker::Lorem.sentence }
    author { association(:user) }
    done { false }

    trait :done do
      done { true }
    end

    trait :loose do
      todo_list { nil }
    end

    trait :with_due_date do
      due_date { Faker::Date.forward(days: 14) }
    end

    trait :with_list do
      todo_list
    end
  end

  factory :subtask do
    sequence(:title) { |n| "Subtask #{n}" }
    parent_todo { association(:todo) }
    author { association(:user) }
    done { false }

    trait :done do
      done { true }
    end
  end

  factory :user_todo do
    user
    todo
  end

  factory :message do
    sequence(:title) { |n| "Message #{n}" }
    body { Faker::Lorem.paragraphs(number: 2).join("\n\n") }
    project
    association :author, factory: :user
  end

  factory :event do
    sequence(:title) { |n| "Event #{n}" }
    description { Faker::Lorem.sentence }
    start_date { Date.tomorrow }
    end_date { Date.tomorrow + 1 }
    project
    association :author, factory: :user
  end

  factory :comment do
    body { Faker::Lorem.sentence }
    association :author, factory: :user
    association :commentable, factory: :message
  end

  factory :note do
    sequence(:title) { |n| "Note #{n}" }
    body { Faker::Lorem.paragraphs(number: 2).join("\n\n") }
    project
    association :author, factory: :user

    trait :root do
      parent { nil }
    end

    trait :child do
      association :parent, factory: :note
    end
  end

  factory :note_link do
    source_note { association(:note) }
    target_note { association(:note) }
  end

  factory :tag do
    sequence(:name) { |n| "tag-#{n}" }
    color { "##{SecureRandom.hex(3)}" }
  end

  factory :tagging do
    tag
    association :taggable, factory: :message
  end
end
