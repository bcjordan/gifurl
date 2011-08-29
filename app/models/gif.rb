require 'json'
require 'net/http'

class Gif < ActiveRecord::Base
  acts_as_taggable

  attr_accessible :name, :url, :nsfw

  validates_presence_of :url

  before_save :ensure_hosted_on_imgur

  private
  def ensure_hosted_on_imgur
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
