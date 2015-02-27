# == Schema Information
#
# Table name: projects
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  production   :string(255)
#  dop          :string(255)
#  pickupday    :datetime
#  returnday    :datetime
#  shootingdays :integer
#  creator_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Project < ActiveRecord::Base
	belongs_to :user
	has_many :assigned_projects, dependent: :destroy
	has_many :users, :through => :assigned_projects
	belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

	has_many :assigned_products
	has_many :products, :through => :assigned_products
	
	has_many :custom_items, dependent: :destroy

#  default_scope -> { order('created_at DESC') }  #  rails 4!
	default_scope order: "projects.created_at DESC"

	attr_accessible :dop, :title, :pickupday, :production, :returnday, :shootingdays, :creator_id, :assigned_projects_attributes

	accepts_nested_attributes_for :assigned_projects#, :allow_destroy => true

	DATE_REGEX = /\d{1,2}:\d{2}/

	validates :title, presence: true, length: { minimum: 3, maximum: 100 }
	validates :production, length: { maximum: 100 }
	validates :dop, length: { maximum: 50 }
	validates_format_of :pickupday, allow_blank: true, with: DATE_REGEX
	validates_format_of :returnday, allow_blank: true, with: /\d{1,2}:\d{2}/
	validates :shootingdays, numericality: { only_integer: true, allow_blank: true }

end
