require 'json'
require 'net/http'
require 'open-uri'
require 'nokogiri'

class Gif < ActiveRecord::Base
  acts_as_taggable
  is_impressionable

  attr_accessible :name, :url, :nsfw, :source, :original_url, :tag_list

  validates_presence_of :url

  validates_uniqueness_of :url
  validates_uniqueness_of :original_url


  before_validation :store_original_url
  before_save :ensure_hosted

  private

  # before_create :check_for_existing
  #def check_for_existing
  #  pp self.url
  #  existing = Gif.find_by_url(self.url) ? Gif.find_by_url(self.url) : Gif.find_by_original_url(self.original_url)
  #  pp existing
  #  self.errors.add_to_base :url, "Link already on the site -- help update its tags or title, its id is #{existing.id}!" if existing
  #end

  def store_original_url
    self.original_url = self.url if !self.original_url
  end

  def ensure_hosted
    if !url.include? "eho.st" and !url.include? "imgur"
      begin
        host_on_imgur
      rescue Exception => e
        puts "ERROR: imgur hosting failed. Falling back to ehost. #{e.message}"
        begin
          host_on_ehost
        rescue Exception => e2
          ## TODO: mark gif as poor quality (e.g., don't show on front page)
          puts "ERROR: ehost hosting failed. Keeping original host. #{e.message}"
        end
      end
    end
  end

  def ensure_hosted_on_ehost
    if !url.include? "eho.st"
      host_on_ehost
    end
  end

  def ensure_hosted_on_imgur
    if !url.include? "imgur"
      host_on_imgur
    end
  end

  def host_on_imgur
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
  end

  def host_on_ehost
    get_url     = "http://eho.st/#{self.url}"
    parser      = Nokogiri::HTML open get_url
    new_gif_url = parser.css('input')[2].attribute('value').value

    if new_gif_url.include? '.gif'
      self.original_url = self.url
      self.url          = new_gif_url
    end
  end
end
