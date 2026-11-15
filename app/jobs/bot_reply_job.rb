class BotReplyJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    prompt = Message.find_by(id: message_id)
    return unless prompt&.bot_prompt?

    Message.find_or_create_by!(in_reply_to_id: prompt.id) do |reply|
      reply.room = prompt.room
      reply.author_name = "Demo Bot"
      reply.kind = :bot
      reply.body = response_for(prompt.body)
    end
  rescue ActiveRecord::RecordNotUnique
    # Another execution already created the one allowed reply.
  end

  private

  def response_for(body)
    command = body.sub(/(?:\A|\s)@bot\b/i, "").strip

    case command.downcase
    when "help"
      "Try @bot help, @bot time, or @bot roll."
    when "time"
      "The server time is #{Time.current.strftime('%H:%M:%S %Z')}."
    when "roll"
      "You rolled a #{rand(1..6)} 🎲"
    else
      "I heard: #{command.presence || 'hello!'}".truncate(1_000)
    end
  end
end
