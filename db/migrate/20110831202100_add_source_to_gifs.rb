class AddSourceToGifs < ActiveRecord::Migration
  def self.up
    add_column :gifs, :source, :string
    add_column :gifs, :original_url, :string
  end

  def self.down
    remove_column :gifs, :source
    remove_column :gifs, :original_url
  end
end
