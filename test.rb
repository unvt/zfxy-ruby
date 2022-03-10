require './zfxy.rb'

p lat2y(14, 35.0)
p lat2y(14, 35)
p point2zfxy(14, 3776, 135, 35)
p zfxy2point(14, 0, 14336, 6489)
p zfxy2bbox(14, 0, 14336, 6489)
print zfxy2geojson(14, 0, 14336, 6489), "\n"
