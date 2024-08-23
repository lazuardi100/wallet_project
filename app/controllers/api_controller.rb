class ApiController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session_token = SecureRandom.hex
      new_session = Session.create!(user_id: user.id, session_token: session_token)
      
      render json: { session_token: session_token }
    else
      render json: { error: "Invalid email or password." }
    end
  end
end
