# == Schema Information
#
# Table name: assigned_products
#
#  id         :integer          not null, primary key
#  quantity   :integer
#  remarks    :string(255)
#  project_id :integer
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AssignedProduct < ActiveRecord::Base

	belongs_to :project
	belongs_to :product

	attr_accessible :product_id, :project_id, :quantity, :remarks

	validates :remarks, length: { maximum: 255 }

end
