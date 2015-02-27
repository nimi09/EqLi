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

require 'test_helper'

class AssignedProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
