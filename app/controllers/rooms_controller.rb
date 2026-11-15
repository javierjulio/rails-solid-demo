class RoomsController < ApplicationController
  def show
    @room = Room.find_by!(slug: params[:id])
    @messages = @room.messages
      .order(created_at: :desc, id: :desc)
      .limit(100)
      .to_a
      .reverse
    @message = @room.messages.new(author_name: session[:chat_name])
    @stats = @room.activity_stats
  end
end
