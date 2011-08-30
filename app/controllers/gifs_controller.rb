require 'open-uri'
require 'pp'

class GifsController < ApplicationController
  def front
    @gifs = Gif.all
    
    @tags = Gif.tag_counts
  end

  def index
    @gifs = Gif.all
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

      if matching_gifs.size <= offset
        offset = matching_gifs.size - 1
      end
      @gif = matching_gifs[offset]
    end

    pp "test" + request.referer

    request.env[:HTTP_REFERER]
    redirect_to @gif.url, :status => 301
    #file = open("#{@gif.url}")
    #send_data file.read, :filename => @gif.id, :type=>'image/gif', :disposition => 'inline'
  end

  def show
    if params[:id]
      @gif = Gif.find(params[:id])
    elsif params[:tag]
      tags = params[:tag].split '+'
      pp tags
      @gif = Gif.tagged_with(tags).first
    end

    pp "test" + request.referer

    #redirect_to @gif.url, :status => 301
    #file = open("#{@gif.url}")
    #send_data file.read, :filename => @gif.id, :type=>'image/gif', :disposition => 'inline'
  end

  def new
    @gif = Gif.new
  end

  def create
    @gif = Gif.new(params[:gif])
    pp "Tags are" + params[:gif][:tags]
    @gif.tag_list = params[:gif][:tags]
    if @gif.save
      redirect_to @gif, :notice => "Successfully created gif."
    else
      render :action => 'new'
    end
  end

  def edit
    @gif = Gif.find(params[:id])

  end

  def update
    @gif = Gif.find(params[:id])
    pp "Tags are" + params[:gif][:tags]
    @gif.tag_list = params[:gif][:tags]
    if @gif.update_attributes(params[:gif])
      redirect_to @gif, :notice  => "Successfully updated gif."
    else
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
end