class AddSubmissionToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :submission, index: true, foreign_key: true
  end
end
