class Comment < ActiveRecord::Base
  belongs_to :submission
  has_many :replies
  has_one :user
  acts_as_votable

  def nvotes
    self.get_up_votes.count
  end

  def timestamp
    self.created_at
  end

  def author_id
    self.user_id
  end


  def as_json(options={})
    super(:methods => [:nvotes, :author_id, :timestamp],
          :include => {:replies => {:only => :id } } ,
          except: [:created_at, :updated_at, :user_id])
  end
end
