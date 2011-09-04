module GifsHelper
  include ActsAsTaggableOn::TagsHelper

  def gifurl params
    styled_url = "http://gifurl.com/"
    url        = "http://gifurl.com/"

    params[:tags].each_with_index do |tag, i|
      styled_url += "#{' ' unless i == 0}#{highlight tag}"
      url        += "#{' ' unless i == 0}#{tag}"
    end

    styled_url += '.'
    url        += '.'

    if params[:offset]
      styled_url += "#{highlight params[:offset]}."
      url        += "#{params[:offset]}."
    end

    styled_url += "gif"
    url        += "gif"

    link_to styled_url.html_safe, url
  end

  def highlight input
    "<span class='highlight'>#{input}</span>".html_safe
  end
end
