define [], () ->

  Fn =
    # Linear interpolation between a and b given ratio
    lerp: (a, b, ratio) ->
      ratio = Math.min(Math.max(ratio, 0), 1)
      a*(1-ratio) + b*ratio

    easeInQuad: (a, b, ratio) ->
      (b-a)*ratio*ratio + a



