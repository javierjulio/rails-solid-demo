class Room < ApplicationRecord
  has_many :messages, dependent: :restrict_with_error

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  def activity_stats
    Rails.cache.fetch(["room-activity", "v1", id], expires_in: 15.seconds) do
      counts = messages.group(:kind).count

      {
        total_messages: counts.values.sum,
        human_messages: counts.fetch("human", 0),
        bot_replies: counts.fetch("bot", 0),
        participants: messages.human.distinct.count(:author_name),
        calculated_at: Time.current.iso8601(3)
      }
    end
  end
end
