class RefreshController < ApplicationController
  before_action :authorize_refresh_request!

  def create
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_allowed do
      # here goes malicious activity alert
      raise JWTSessions::Errors::Unauthorized, "Refresh action is performed before the expiration of the access token."
    end
    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)
    render json: { csrf: tokens[:csrf] }
  end

  def access_payload
    # payload here stands for refresh token payload
    build_access_payload_based_on_refresh(payload)
  end
end