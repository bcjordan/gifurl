class CreateGifs < ActiveRecord::Migration
  def self.up
    create_table :gifs do |t|
      t.string :name
      t.string :url
      t.boolean :nsfw
      t.timestamps
    end
  end

  def self.down
    drop_table :gifs
  end
end
