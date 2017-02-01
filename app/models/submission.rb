class Submission < ActiveRecord::Base
  has_one :user
  has_many :comments
  acts_as_votable
  validate :titulo

  def titulo
    if title.blank?
      errors.add(:title, "- Title can't be blank")
    else
      if !url.blank? && url =~ URI::regexp
        if content.blank?
        else 
          errors.add(:url, "- Stories can't have both urls and text, so you need to pick one")
          errors.add(:content, "")
        end
      elsif !url.blank?
        errors.add(:url, "- Invalid Url")
      else 
      end
    end
  end


  def author_id
    self.user_id
  end

  def ncomments
    self.comments.size
  end

  def nvotes
    self.get_up_votes.count
  end

  def timestamp
    self.created_at
  end

  def as_json(options={})
    super(:methods => [:ncomments, :nvotes, :author_id, :timestamp],
          :include => {:comments => {:only => :id } } ,
          except: [:created_at, :updated_at, :user_id])
  end
end
