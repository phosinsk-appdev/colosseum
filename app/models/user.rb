# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  has_many(:events, { :class_name => "Event", :foreign_key => "creator_id", :dependent => :destroy })
  has_many(:donations, { :class_name => "Donation", :foreign_key => "donator_id" })

end
