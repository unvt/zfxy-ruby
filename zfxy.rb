Z_ONE = 25
H = 2 ** Z_ONE

def n(z)
  2 ** z
end

def height2f(z, h)
  (n(z) * h / H).floor
end

def lng2x(z, lng)
  (n(z) * ((lng + 180.0) / 360)).floor
end

def lat2y(z, lat)
  rad = lat / 180.0 * Math::PI
  ((1.0 - Math::log(
    Math::tan(rad) + (1 / Math::cos(rad))
  ) / Math::PI) / 2.0 * n(z)).floor
end

def point2zfxyArray(z, h, lng, lat)
  [z, height2f(z, h), lng2x(z, lng), lat2y(z, lat)]
end

def point2zfxy(z, h, lng, lat)
  point2zfxyArray(z, h, lng, lat).join('/')
end

def f2height(z, f)
  if z > Z_ONE
    f.to_f * H / n(z)
  else
    f * H / n(z)
  end
end

def x2lng(z, x)
  360.0 * x / n(z) - 180.0
end

def y2lat(z, y)
  rad = Math::atan(
          Math::sinh(Math::PI * (1 - 2.0 * y / n(z))))
  180.0 * (rad / Math::PI)
end

def zfxy2point(z, f, x, y)
  [z, f2height(z, f), x2lng(z, x), y2lat(z, y)]
end

def zfxy2bbox(z, f, x, y)
  e = x2lng(z, x + 1)
  w = x2lng(z, x)
  s = y2lat(z, y + 1)
  n = y2lat(z, y)
  [w, s, e, n]
end

def zfxy2geojson(z, f, x, y)
  bbox = zfxy2bbox(z, f, x, y)
  f = {
    :type => 'Feature',
    :geometry => {
      :type => 'Polygon',
      :coordinates => [[
        [bbox[0], bbox[3]],
        [bbox[0], bbox[1]],
        [bbox[2], bbox[1]],
        [bbox[2], bbox[3]],
        [bbox[0], bbox[3]]
      ]]
    },
    :properties => {
      :base => f2height(z, f),
      :height => f2height(z, 1),
      #:code => "#{z}/#{f}/#{x}/#{y}",
      :z => z,
      :f => f,
      :x => x,
      :y => y,
      :parity => (f + x + y) % 2
    }
  }
  f
end

def zfxy_parent(z, f, x, y)
  [z - 1, f / 2, x / 2, y / 2]
end

def zfxy_children(z, f, x, y)
  2.times {|df|
    2.times {|dx|
      2.times {|dy|
        yield [
          z + 1, 
          2 * f + df,
          2 * x + dx,
          2 * y + dy
        ]
      }
    }
  }
end

