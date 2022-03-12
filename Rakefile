MAX_ZOOM = 23
MIN_ZOOM = 12
DELTA_ZOOM = 4
# MAX_HEIGHT = 1000

require './zfxy.rb'
require 'json'

task :host do
  sh "budo -d docs"
end

task :style do
  sh <<-EOS
charites --provider mapbox build style.yml docs/style.json
  EOS
end

task :geojsons do
  def dump(z, f, x, y)
    f = zfxy2geojson(z, f, x, y)
#    return if f[:properties][:base] > MAX_HEIGHT
#    return unless f[:properties][:f] == 0
    f[:tippecanoe] = {
      :layer => 'zfxy',
      :maxzoom => z - DELTA_ZOOM,
      :minzoom => z - DELTA_ZOOM
    }
    print "\x1e#{JSON.dump(f)}\n"
  end
  def jump_into(z, f, x, y)
return if f > 0
    dump(z, f, x, y)
    if z < MAX_ZOOM
      zfxy_children(z, f, x, y) {|zfxy|
        jump_into(*zfxy)
      }
    end
  end
  jump_into(MIN_ZOOM, 0, 3637, 1613)
end

task :tiles do
  sh <<-EOS
rake geojsons | \
tippecanoe --output-to-directory=docs/zxy --force \
--no-tile-compression --minimum-zoom=#{MIN_ZOOM - DELTA_ZOOM} \
--maximum-zoom=#{MAX_ZOOM - DELTA_ZOOM}
  EOS
end
