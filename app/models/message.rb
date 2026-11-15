class Message < ApplicationRecord
  belongs_to :room
  belongs_to :in_reply_to, class_name: "Message", optional: true

  enum :kind, {
    human: "human",
    bot: "bot"
  }, default: :human, validate: true

  validates :author_name, presence: true, length: { maximum: 40 }
  validates :body, presence: true, length: { maximum: 1_000 }

  validate :reply_relationship_is_valid

  after_create_commit :broadcast_message
  after_create_commit :enqueue_bot_reply, if: :bot_prompt?

  def bot_prompt?
    human? && body.match?(/(?:\A|\s)@bot\b/i)
  end

  private

  def reply_relationship_is_valid
    if human? && in_reply_to_id.present?
      errors.add(:in_reply_to, "is only for bot messages")
    elsif bot?
      if in_reply_to.nil?
        errors.add(:in_reply_to, "must be present for a bot reply")
      elsif !in_reply_to.human? || in_reply_to.room_id != room_id
        errors.add(:in_reply_to, "must be a human message in the same room")
      end
    end
  end

  def broadcast_message
    broadcast_append_to(
      room,
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end

  def enqueue_bot_reply
    BotReplyJob.set(wait: 2.seconds).perform_later(id)
  end
end
