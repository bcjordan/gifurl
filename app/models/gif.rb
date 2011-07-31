class Gif < ActiveRecord::Base
  acts_as_taggable

  attr_accessible :name, :url, :nsfw
end
