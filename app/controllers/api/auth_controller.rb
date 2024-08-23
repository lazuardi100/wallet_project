class Api::AuthController < Api::BaseController
  skip_before_action :check_session

  def login
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      current_session = Session.find_by(user_id: user.id)
      if !(current_session.present?) && current_session.created_at < 1.day.ago
        session_token = SecureRandom.hex
        new_session = Session.create!(user_id: user.id, session_token: session_token)
      else
        session_token = current_session.session_token
      end
      
      render json: { session_token: session_token }
    else
      render json: { error: "Invalid email or password." }
    end
  end
end
