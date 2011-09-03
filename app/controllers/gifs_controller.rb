#require 'rubygems'
require 'open-uri'
require 'pp'
require 'nokogiri'

class GifsController < ApplicationController
  def front
    @gifs = Gif.all
  end

  def index
    @tags = Gif.where(:nsfw => nil).tag_counts
    @gifs = Gif.all if !@gifs || @gifs.empty?
  end

  def tag_cloud
    @tags = Post.tag_counts_on(:tags)
  end

  def jump
    if params[:tag].is_numeric?
      @gif = Gif.all[(params[:tag].to_i)]
    elsif params[:tag]
      tags = params[:tag].split '+'
      offset = params[:offset] ? params[:offset].to_i : 1

      offset = offset - 1 # Move from 1 bottom to 0 bottom

      matching_gifs = Gif.tagged_with(tags)
      matching_gifs += Gif.tagged_with(params[:tag].split ' ')

      pp params[:tag].split ' '
      if matching_gifs.size <= offset
        offset = matching_gifs.size - 1
      end
      @gif = matching_gifs[offset]
    end

    if @gif
      redirect_to @gif.url, :status => 301
    else
      redirect_to index_path
    end
    #file = open("#{@gif.url}")
    #send_data file.read, :filename => @gif.id, :type=>'image/gif', :disposition => 'inline'
  end

  def tag
    @gifs = Gif.tagged_with params[:tag]
  end

  def show
    if params[:id]
      @gif = Gif.find(params[:id])
    elsif params[:tag]
      tags = params[:tag].split '+'
      pp tags
      @gif = Gif.tagged_with(tags).first
    end

    #redirect_to @gif.url, :status => 301
    #file = open("#{@gif.url}")
    #send_data file.read, :filename => @gif.id, :type=>'image/gif', :disposition => 'inline'
  end

  def new
    @gif = Gif.new
    @gif.url = "http://#{params[:url]}" if params[:url]
  end

  def create
    @gif = Gif.new(params[:gif])
    # params[:gif][:tags]
    if @gif.save
      redirect_to @gif, :notice => "Successfully created gif."
    else
      render :action => 'new'
    end
  end

  def edit
    @gif = Gif.find(params[:id])
  end

  def import
    
  end

  def batch_edit
    if params[:batch_edit]
      if params[:batch_edit][:range] && params[:batch_edit][:range] != ''
        range = params[:batch_edit][:range].to_range
        @gifs = Gif.where(:id => range)
      elsif params[:batch_edit][:name] &&
           (params[:batch_edit][:name] != '' || params[:batch_edit][:name] == 'blank')
        if params[:batch_edit][:name] == 'blank'
          params[:batch_edit][:name] = ''
        end
        @gifs = Gif.find_all_by_name(params[:batch_edit][:name])
      elsif params[:batch_edit][:tag_list]
        if params[:batch_edit][:tag_list] == ''
          @gifs = Gif.tagged_with []
          pp 'hello'
        else
          @gifs = Gif.tagged_with params[:batch_edit][:tag_list]
        end
      end
    else
      @gifs = []
    end
  end

  def review
    @gifs = []
    urls = {}

    ## Grab HTML from URL
    begin
      urls = {}
      ## TODO: add range handling and multi-URL parsing
      doc = Nokogiri::HTML(open(params[:import][:url]))
      doc.css('a').each do |image|
        if image['src'] && image['src'].include?('.gif') && !image['src'].include?('pixel')
          urls[image['src']] = true
        elsif image['href'] && image['href'] && image['href'].include?('.gif')
          urls[image['href']] = true
        end
      end

      urls.each do |url, value|
        @gifs << Gif.create(:url => url, :source => params[:import][:url])
      end
    rescue Exception => e
      flash.now[:error] = "The URL <a href='#{params[:import][:url]}'>#{params[:import][:url]}</a> could not be accessed or parsed.".html_safe
      puts e
      render :action => 'import'
    end

    #session[:gifs] = @gifs
  end

  def update_batch
    @gifs = []

    params[:gifs].each do |key, gif|
      if gif['include'] == '1'
        new_gif = Gif.find_or_create_by_url(gif[:url])
        new_gif.update_attributes(gif)
        new_gif.tag_list = gif[:tag_list]
        
        @gifs << new_gif if new_gif.save
      else
        Gif.find_by_url(gif[:url]).destroy if Gif.find_by_url(gif[:url])
      end
    end

    redirect_to :action => 'index', :notice => "Successfully created these #{@gifs.size} gifs"
  end

  def update
    @gif = Gif.find(params[:id])
    
    if @gif.update_attributes(params[:gif])
      redirect_to @gif, :notice => "Successfully updated gif."
    else
      ## TODO: save tag list
      render :action => 'edit'
    end
  end

  def destroy
    @gif = Gif.find(params[:id])
    @gif.destroy
    redirect_to gifs_url, :notice => "Successfully destroyed gif."
  end
end

class String
  def is_numeric?
    Float(self)
    true
  rescue
    false
  end

  def to_range
    case self.count('.')
      when 1
        return Range.new(self.to_i, self.to_i)
      when 2
        elements = self.split('..')
        return Range.new(elements[0].to_i, elements[1].to_i)
      when 3
        elements = self.split('...')
        return Range.new(elements[0].to_i, elements[1].to_i-1)
      else
        raise ArgumentError.new("Couldn't convert to Range: #{str}")
    end
  end
end