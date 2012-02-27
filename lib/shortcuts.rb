Magickly.dragonfly.configure do |c|
  c.analyser.add :color_palette do |temp_object, num_colors|
    num_colors = num_colors.blank? ? Magickly::DEFAULT_PALETTE_COLOR_COUNT : num_colors.to_i
    output = `convert #{temp_object.path} -resize 600x600 -colors #{num_colors} -format %c -depth 8 histogram:info:-`
    
    palette = []
    output.scan(/\s+(\d+):[^\n]+#([0-9A-Fa-f]{6})/) do |count, hex|
      palette << { :count => count.to_i, :hex => hex }
    end
    palette
  end
end
