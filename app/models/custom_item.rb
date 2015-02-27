# == Schema Information
#
# Table name: custom_items
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  included_acc :string(255)
#  quantity     :integer
#  remark       :string(255)
#  price        :float
#  project_id   :integer
#  category_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CustomItem < ActiveRecord::Base

	belongs_to :project
	belongs_to :category

	attr_accessible :category_id, :included_acc, :name, :price, :project_id, :quantity, :remark

	validates :quantity, presence: true, numericality: true
	validates :name, presence: true, length: { minimum: 3, maximum: 100 }
	validates :category_id, presence: true

	validates :included_acc, length: { maximum: 255 }
	validates :remark, length: { maximum: 255 }
end
