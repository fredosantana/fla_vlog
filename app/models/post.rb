class Post < ApplicationRecord
	validates :name, presence: true
	validates :address, presence: true
	validates :description, presence: true
	validates :picture, presence: true
	has_many :comments

	mount_uploader :picture, PictureUploader
	
	belongs_to :admin
end
