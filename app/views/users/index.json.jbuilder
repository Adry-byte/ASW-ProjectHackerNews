json.array!(@users) do |user|
  json.extract! user, :id, :username, :email, :password, :about, :created_at, :updated_at
end
