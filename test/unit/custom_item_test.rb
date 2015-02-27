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

require 'test_helper'

class CustomItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
