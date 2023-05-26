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

  # donations checks to update event status

  after_save :update_event_status

  private

  def update_event_status
    event = self.event
    if event.donations.sum(:donation) >= event.funding_target
      event.update(status: "funded")
    elsif event.status == "created" && event.donations.sum(:donation) > 0
      event.update(status: "funding_in_progress")
    end
  end

end
