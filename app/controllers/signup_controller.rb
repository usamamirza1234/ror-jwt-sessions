class SignupController < ApplicationController
  def create
    user = User.new(signup_params)
    if user.save
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens= session.login
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf] }
    else
      render json: {error: "Invalid user", message: user.errors.full_messages.join(' ') }, status: :unauthorized
    end
  end
  private
  def signup_params
    params.permit(:email, :password, :password_confirmation)
  end
end