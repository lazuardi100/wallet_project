json.extract! session, :id, :user_id, :session_token, :created_at, :updated_at
json.url session_url(session, format: :json)
