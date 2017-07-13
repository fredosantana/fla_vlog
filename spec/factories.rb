FactoryGirl.define do
	factory :admin do
		sequence :email do |n|
			"dummyEmail#{n}@gmail.com"
		end
		password "secretPassword"
		password_confirmation "secretPassword"
	end
end