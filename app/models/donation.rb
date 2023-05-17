# == Schema Information
#
# Table name: donations
#
#  id         :integer          not null, primary key
#  donation   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  donator_id :integer
#  event_id   :integer
#
class Donation < ApplicationRecord

  # validations
  validates(:donation, { :numericality => { :greater_than => 0 } })
  validates(:donation, { :presence => { :message => "Please enter the donation amount. " } })

  # association accessors
  belongs_to(:event, { :required => true, :class_name => "Event", :foreign_key => "event_id" })
  belongs_to(:donator, { :required => true, :class_name => "User", :foreign_key => "donator_id" })

end
