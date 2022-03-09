H = 2 ** 26

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

