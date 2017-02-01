class AddCommentToReply < ActiveRecord::Migration
  def change
    add_reference :replies, :comment, index: true, foreign_key: true
  end
end
