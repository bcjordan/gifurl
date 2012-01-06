# GifURL

GifURL is an animated gif URL forwarding and automated rehosting service. It has a bit of a cult following for its speed of discovery and referencing of animated gifs appropriate to message board discussions.

## Motivation

My motivation was a simple frustration -- finding and linking to animated gifs used to take *forever*. Many sites will show you a gif but hide the direct gif URL in a CSS div background. I decided to build something that lets you reference a commonly used gif without even needing to touch your address bar.

## Components

GifURL has three pretty interesting functions. First, its URL [routes](https://github.com/bcjordan/gifurl/blob/master/config/routes.rb) and [controllers](https://github.com/bcjordan/gifurl/blob/master/app/controllers/gifs_controller.rb) allow for lightning-fast gif lookup and gif addition/rehosting.

* http://gifurl.com/popcorn.gif performs an http 301 redirect to the most popular gif tagged with "popcorn"
* [http://gifurl.com/popcorn](http://gifurl.com/popcorn "GifURL Popcorn gifs") goes to a page full of "popcorn" gifs
* http://gifurl.com/http://some-url.com/somefile.gif - rehosts that gif and prompts for tags

Second, GifURL's Gif [model](https://github.com/bcjordan/gifurl/blob/master/app/models/gif.rb) handles re-uploading of gifs to a trusted long-term host (imgur.com, falling back to eho.st for larger gifs). Gif addition is so quick and easy, GifURL has rehosted over 1000 tagged gifs since this September.

Third, GifURL has a multi-page website scraping interface that allows for mass uploading, tagging and re-hosting of gifs. That can be found in the [gif review](https://github.com/bcjordan/gifurl/blob/master/app/controllers/gifs_controller.rb#L114) controller.

## Contributing

Contributions are encouraged and new issues are added to the [issues page](https://github.com/bcjordan/gifurl/issues?sort=created&amp;direction=desc&amp;state=open) often.

Help out by reporting bugs, adding to the wiki and letting me know what you're using gifurl for.

A new version of gifurl which uses its own CDN is being worked on at [gifurl2](https://github.com/bcjordan/gifurl2).

## Bonus Gifs

![](http://i.imgur.com/GM274.gif) ![](http://i.imgur.com/BX1b9.gif) ![](http://i.imgur.com/shEVa.gif) ![](http://i.eho.st/pgr16es6.gif)