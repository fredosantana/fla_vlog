class Post < ApplicationRecord
	validates :name, presence: true

	belongs_to :admin
end
