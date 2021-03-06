class User < ActiveRecord::Base
  has_many :teamrosters
  has_many :teams, through: :teamrosters

  has_many :tournament_attendances
  has_many :tournaments, through: :tournament_attendances

  has_many :invitations

  acts_as_messageable

  def mailboxer_email
    'string'
  end

  def get_ggp
    ggp = self.ggp.to_i
    self.teams.each { |x| ggp += x.xp unless x.xp.nil? }
    ggp
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end