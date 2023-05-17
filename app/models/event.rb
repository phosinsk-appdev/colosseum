# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  battle_report  :text
#  date_deadline  :date
#  date_target    :date
#  description    :text
#  funding_target :float
#  status         :string
#  title          :string
#  watch_details  :text
#  winning_team   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :integer
#  game_id        :integer
#

class Event < ApplicationRecord

  # validations
  validates(:title, { :presence => { :message => "Please enter a title for your event." } })
  validates(:title, { :uniqueness => { :scope => ["game_id"], :message => "It looks like an event by this name / for this game already exists. Please edit the title or the game selection." } })
  validates(:status, { :inclusion => { :in => [ "created", "funding_in_progress", "funded", "complete" ] } })
  validates(:status, { :presence => true })
  validates(:game_id, { :presence => { :message => "Please enter the desired game for your event." } })
  validates(:funding_target, { :numericality => { :greater_than => 0, :less_than_or_equal_to => 100000 } })
  validates(:funding_target, { :presence => { :message => "Please enter a funding target for your event." } })
  validates(:description, { :presence => { :message => "Please enter a description for your event." } })
  validates(:date_deadline, { :presence => { :message => "Please enter a deadline date for your event." } })
  validates(:creator_id, { :presence => true })

  validate :deadline_date_after_target_date

  def deadline_date_after_target_date
    if date_deadline.present? && date_deadline < date_target
      errors.add(:date_deadline, "Deadline date cannot be prior to the target date")
    end
  end

  # association accessors
  has_many(:donations, { :class_name => "Donation", :foreign_key => "event_id" })
  has_many(:events_players, { :class_name => "EventsPlayer", :foreign_key => "event_id", :dependent => :destroy })
  belongs_to(:creator, { :required => true, :class_name => "User", :foreign_key => "creator_id" })
  belongs_to(:game, { :required => true, :class_name => "Game", :foreign_key => "game_id" })

end
