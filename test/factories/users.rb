Factory.define :user do |u|
  u.name 'User'
  u.color 000000
  u.sequence(:login) {|n| "user#{n}" }
  u.sequence(:email) {|n| "user#{n}@agilar.org" }
  u.password 'test'
  u.password_confirmation 'test'
end
