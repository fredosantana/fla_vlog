class Post < ApplicationRecord
	validates :name, presence: true
	validates :address, presence: true
	validates :description, presence: true
	validates :picture, presence: true

	mount_uploader :picture, PictureUploader
	
	belongs_to :admin
end
