class Movie < ActiveRecord::Base
  def self.Ratings
    select(:rating).map(&:rating).uniq
  end

end
