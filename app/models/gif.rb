require 'json'
require 'net/http'

class Gif < ActiveRecord::Base
  acts_as_taggable

  attr_accessible :name, :url, :nsfw, :source, :original_url

  validates_presence_of :url

  validates_uniqueness_of :url, :original_url

  before_save :ensure_hosted_on_imgur

  private
  #http://www.imageshack.us/upload_api.php?key=57CHKLNO23f5772890d33fccf87b99c997caf3bc&url=http://30.media.tumblr.com/tumblr_l5seo7bH9R1qci224o1_250.gif
  
  def ensure_hosted_on_imgur
    self.original_url = self.url
    
    if !url.include? "imgur"
      host_on_imgur
    end
  end

  def host_on_imgur
    begin
      res = Net::HTTP.post_form(URI.parse('http://api.imgur.com/2/upload.json'),
                                {'key'         => '41c9fb1cc18d7e6ea82e4d46eaa9ca0c',
                                 'image'       => self.url,
                                 'content-type'=>'image/gif'})

      # To handle uploads:
      # 'image' => Base64.encode64(open(url).read),
      puts res.body

      self.url = JSON.parse(res.body)['upload']['links']['original']

      puts self.url
      puts JSON.parse(res.body)['upload']['image']['hash']
    rescue
      puts "ERROR: imgur update failed"
    end
  end
end
