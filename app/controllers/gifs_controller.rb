require 'open-uri'

class GifsController < ApplicationController
  def index
    @gifs = Gif.all
  end

  def show
    if params[:id]
      @gif = Gif.find(params[:id])
    elsif params[:tag]
      @gif = Gif.tagged_with(params[:tag]).first
    end

    #redirect_to @gif.url, :status=>302
    file = open("#{@gif.url}")
    send_data file.read, :filename => @gif.id, :type=>'image/gif', :disposition => 'inline'
  end

  def new
    @gif = Gif.new
  end

  def create
    @gif = Gif.new(params[:gif])
    @gif.tag_list.add params[:gif][:tags]
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
    @gif.tag_list.add params[:gif][:tags]
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
