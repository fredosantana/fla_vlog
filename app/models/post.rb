class Post < ApplicationRecord
	validates :name, presence: true
	mount_uploader :picture, PictureUploader
	belongs_to :admin
end
