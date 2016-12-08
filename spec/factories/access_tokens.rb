FactoryGirl.define do
  factory :access_token do
    token_digest nil
    accessed_at "2016-12-06 19:38:42"
    user
    api_key
  end
end
