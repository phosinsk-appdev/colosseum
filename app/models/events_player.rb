# == Schema Information
#
# Table name: events_players
#
#  id         :integer          not null, primary key
#  team       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer
#  player_id  :integer
#
class EventsPlayer < ApplicationRecord

  belongs_to(:event, { :required => true, :class_name => "Event", :foreign_key => "event_id" })
  belongs_to(:player, { :required => true, :class_name => "Player", :foreign_key => "player_id" })

  validates(:player_id, {:uniqueness => { :scope => ["event_id"], :message => "has already been added to this event" }})

end
