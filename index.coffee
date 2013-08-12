
$ = require('jquery')

class StretchDiv
  constructor: (options={})->
    @div_dom = $(options.div)
    @img_dom = if options.img then $(options.img) else false

    @inners = []

    @resize()
    @bind()

  bind: ()=>
    $(window).resize(@resize)

  resize: ()=>
    @div_dom.height(window.innerHeight)
    @div_dom.width(window.innerWidth)

    if @img_dom
      if @img_dom.width() > 0 and @img_dom.height() > 0
        if not @image_ratio?
          @image_ratio = @img_dom.width() / @img_dom.height()
        container = @div_dom
        container_ratio = container.width() / container.height()
        if @image_ratio >= container_ratio
          @img_dom.css('height', '100%')
          @img_dom.css('width', 'auto')
          padding_top = 0.0
          padding_left = (-1 * ( (@image_ratio * container.height() - container.width() ) ) / 2)
        else
          @img_dom.css('height', 'auto')
          @img_dom.css('width', '100%')
          padding_top =  (-1 * ( (container.width() / @image_ratio) - container.height() ) / 2)
          padding_left = 0.0
        @img_dom.offset({top: padding_top, left: padding_left})
        for inner in @inners
          div = inner.div
          div.height(@img_dom.height() * inner.height)
          div.width(@img_dom.width() * inner.width)
          div.offset({left: @img_dom.width() * inner.left + padding_left, top: (@img_dom.height() * inner.top) + padding_top})
      else
        @img_dom.bind "load", ()=>
          @resize()

  inner: (options={})=>
    @inners.push(options)
    @resize()

module.exports = StretchDiv