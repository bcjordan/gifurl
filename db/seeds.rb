# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

gifs = Gif.create([
  { :name => "Michael Jackson eating popcorn", :url => 'http://imgur.com/tCp90.gif' }])

gifs.first.tag_list.add 'popcorn', 'entertained', 'michael jackson', 'jackson'
gifs.first.save!