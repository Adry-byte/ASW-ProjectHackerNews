json.array!(@replies) do |reply|
  json.extract! reply, :id, :content, :created_at, :updated_at, :user_id, :comment_id
end
