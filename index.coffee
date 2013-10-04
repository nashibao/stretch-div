
$ = require('jquery')

class StretchDiv
  constructor: (options={})->
    @div_dom = $(options.div)
    @img_dom = if options.img then $(options.img) else false

    @resized = options.resized || false

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
          # base
          if inner.base_top
            base_top = inner.base_top.offset().top
          else
            base_top = padding_top
          if inner.base_left
            base_left = inner.base_left.offset().left
          else
            base_left = padding_left
          if inner.base_height
            base_height = inner.base_height.height()
          else
            base_height = @img_dom.height()
          if inner.base_width
            base_width = inner.base_width.width()
          else
            base_width = @img_dom.width()

          div.offset({left: base_width * inner.left + base_left, top: (base_height * inner.top) + base_top})

          if inner.height?
            div_height = base_height * inner.height
            div.height(div_height)
          else if inner.bottom?
            div.css({bottom: base_height * inner.bottom + padding_top})
          if inner.width
            div_width = base_width * inner.width
            div.width(div_width)
          else if inner.right?
            div.css({right: base_width * inner.right + padding_left})
            # div_height = base_height * (1 - inner.top - inner.bottom)
            # div_width = base_width * (1 - inner.left - inner.right)
            # div.height(div_height)
            # div.width(div_width)
          
      else
        @img_dom.bind "load", ()=>
          @resize()
    if @resized
      @resized()

  inner: (options={})=>
    @inners.push(options)
    @resize()

module.exports = StretchDiv