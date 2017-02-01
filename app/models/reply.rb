class Reply < ActiveRecord::Base
    belongs_to :comments
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
              except: [:created_at, :updated_at, :user_id])
    end
end
