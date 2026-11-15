class RoomStatsController < ApplicationController
  def show
    @room = Room.find_by!(slug: params[:room_id])
    @stats = @room.activity_stats
  end
end
