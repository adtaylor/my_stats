json.array!(@notifications) do |notification|
  json.extract! notification, :id, :provider, :body, :user_id
  json.url notification_url(notification, format: :json)
end
