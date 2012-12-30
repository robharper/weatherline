define ['./fn'], (Fn) ->

  Color = 
    colorHexToComponents: (color) ->
      [(color & 0xFF0000) >> 16, (color & 0x00FF00) >> 8, (color & 0x0000FF)]

    colorComponentsToHex: (color) ->
      ((color[0] & 0xFF)<<16) + ((color[1] & 0xFF)<<8) + (color[2] & 0xFF)

    colorLerp: (a, b, ratio) ->
      a = Color.colorHexToComponents(a)
      b = Color.colorHexToComponents(b)
      result = [Fn.lerp(a[0], b[0], ratio), Fn.lerp(a[1], b[1], ratio), Fn.lerp(a[2], b[2], ratio)]
      Color.colorComponentsToHex(result)