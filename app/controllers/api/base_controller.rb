class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_session

  def check_session
    # check bearer token
    session_token = request.headers["Authorization"]
    if session_token.present?
      session = Session.find_by(session_token: session_token)
      if session.present?
        if session.created_at < 1.day.ago
          session.destroy
          render json: { error: "Session expired." }
        else
          @current_user = session.user
        end
      else
        render json: { error: "Invalid session token." }
      end
    else
      render json: { error: "Session token required." }
    end
  end
end
