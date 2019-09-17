class Team < ApplicationRecord
  has_many :team_members
  has_many :users, through: :team_members, dependent: :destroy

  alias_attribute :members, :users
end
