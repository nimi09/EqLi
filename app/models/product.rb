# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :string(255)
#  included_acc :string(255)
#  thumb_url    :string(255)
#  category_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Product < ActiveRecord::Base

	belongs_to	:category	
	has_many 	:assigned_products
	has_many	:projects, :through => :assigned_products

	attr_accessible :name, :description, :included_acc, :thumb_url, :category_id, :string

	validates :name, presence: true, length: { minimum: 3, maximum: 100 }, uniqueness: { case_sensitive: false }
	validates :category_id, presence: true

	validates :description, length: { maximum: 255 }
	validates :included_acc, length: { maximum: 255 }
	validates :thumb_url, length: { maximum: 255 }

end
