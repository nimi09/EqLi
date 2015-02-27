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

class AssignedProject < ActiveRecord::Base

	belongs_to :user
	belongs_to :project

	attr_accessible :project_id, :user_id

	accepts_nested_attributes_for :project
  
end
