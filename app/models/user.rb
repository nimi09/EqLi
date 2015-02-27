# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	has_many :assigned_projects, dependent: :delete_all
	has_many :projects, :through => :assigned_projects, dependent: :delete_all

	has_many :created_projects, :class_name => "Project", :foreign_key => :creator_id, :dependent => :delete_all

	attr_accessible :name, :email, :password, :password_confirmation, :assigned_projects_attributes
	has_secure_password

	before_save { |user| user.email = email.downcase }
	before_create :create_remember_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	after_validation { self.errors.messages.delete(:password_digest) }

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
#			self.remember_token = SecureRandom.urlsafe_base64
		end

end
