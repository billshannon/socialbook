class Status < ActiveRecord::Base
	belongs_to :user

	validates :content, { presence: :true, length: { minimum: 2 }}
	validates :user, { presence: true }
end
