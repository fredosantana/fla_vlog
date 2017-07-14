FactoryGirl.define do
	factory :admin do
		sequence :email do |n|
			"dummyEmail#{n}@gmail.com"
		end
		password "secretPassword"
		password_confirmation "secretPassword"
	end

	factory :post do
    name "hello"
    description "testing"
    address "testing"
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.jpg'), 'image/jpg' ) }
    association :admin
  end
end