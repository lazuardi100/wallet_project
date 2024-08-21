require 'bcrypt'
class SessionsController < ApplicationController
  before_action :set_session, only: %i[ show edit update ]

  # GET /sessions or /sessions.json
  def index
  end

  def register
  end

  def sign_up
    # check password with password confirmation
    if params[:password] != params[:password_confirmation]
      flash[:error] = "Password and password confirmation do not match."
      return redirect_to register_path
    end

    existing_user = User.find_by(email: params[:email])
    if existing_user
      flash[:error] = "Email already exists."
      return redirect_to register_path
    end

    ActiveRecord::Base.transaction do
      hashed_password = BCrypt::Password.create(params[:password])
      new_user = User.new(
        email: params[:email],
        password_digest: hashed_password,
        name: params[:name]
      )
  
      if new_user.save
        session_token = SecureRandom.hex
        new_session = Session.create!(user_id: new_user.id, session_token: session_token)
        session[:user_id] = new_user.id
        session[:session_token] = session_token

        flash[:success] = "Welcome, #{new_user.name}!"
        redirect_to root_path
      else
        flash[:error] = new_user.errors.full_messages.join(", ")
        redirect_to register_path
      end
    end
  end

  # GET /sessions/1 or /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
    @session = Session.new
  end

  # GET /sessions/1/edit
  def edit
  end

  # POST /sessions or /sessions.json
  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session_token = SecureRandom.hex
      new_session = Session.create!(user_id: user.id, session_token: session_token)
      session[:user_id] = user.id
      session[:session_token] = session_token

      flash[:success] = "Welcome, #{user.name}!"
      redirect_to root_path
    else
      flash[:error] = "Invalid email or password."
      redirect_to login_path
    end
  end

  # PATCH/PUT /sessions/1 or /sessions/1.json
  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to session_url(@session), notice: "Session was successfully updated." }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1 or /sessions/1.json
  def destroy
    current_user = Session.where(session_token: session[:session_token]).first
    current_user.destroy!

    session.clear
    redirect_to login_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def session_params
      params.require(:session).permit(:user_id, :session_token)
    end
end
