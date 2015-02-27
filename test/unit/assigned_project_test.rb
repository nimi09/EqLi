# == Schema Information
#
# Table name: assigned_projects
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AssignedProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
