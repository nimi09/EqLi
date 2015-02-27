# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
	has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
	belongs_to :parent_category, :class_name => "Category"

	has_many :products

	has_many :custom_items

	attr_accessible :name, :parent_id

	validates :name, presence: true, length: { minimum: 3, maximum: 75 }
	
end
