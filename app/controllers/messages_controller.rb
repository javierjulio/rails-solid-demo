class MessagesController < ApplicationController
  def create
    @room = Room.find_by!(slug: params[:room_id])
    @message = @room.messages.new(message_params.merge(kind: :human))

    if @message.save
      session[:chat_name] = @message.author_name
      reset_form = @room.messages.new(author_name: session[:chat_name])

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "message_form",
            partial: "messages/form",
            locals: { room: @room, message: reset_form }
          )
        end
        format.html { redirect_to room_path(@room), status: :see_other }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "message_form",
            partial: "messages/form",
            locals: { room: @room, message: @message }
          ), status: :unprocessable_entity
        end
        format.html do
          @messages = @room.messages
            .order(created_at: :desc, id: :desc)
            .limit(100)
            .to_a
            .reverse
          @stats = @room.activity_stats
          render "rooms/show", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def message_params
    params.expect(message: %i[author_name body])
  end
end
