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
    if params[:id]
      @gif = Gif.find(params[:id])
    elsif params[:tag]
      tags = params[:tag].split '+'
      pp tags
      @gif = Gif.tagged_with(tags).first
    end

    pp "test" + request.referer

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
