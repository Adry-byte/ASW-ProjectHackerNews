json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :created_at, :updated_at, :user_id, :submission_id, :reply_ids
end
