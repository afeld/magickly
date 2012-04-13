module Magickly

  module ConvertHelpers

    # Mostly copied from dragonfly
    def crop_args opts = {}
      width   = opts[:width]
      height  = opts[:height]
      gravity = Dragonfly::ImageMagick::Processor::GRAVITIES[opts[:gravity]]
      x       = "#{opts[:x] || 0}"
      x = '+' + x unless x[/^[+-]/]
      y       = "#{opts[:y] || 0}"
      y = '+' + y unless y[/^[+-]/]
      repage  = opts[:repage] == false ? '' : '+repage'
      resize  = opts[:resize]
      
      "#{"-resize #{resize} " if resize}#{"-gravity #{gravity} " if gravity}-crop #{width}x#{height}#{x}#{y} #{repage}"
    end

    # Mostly copied from dragonfly
    def resize_and_crop_args opts = {}
      if !opts[:width] && !opts[:height]
        return ""
      elsif !opts[:width] || !opts[:height]
        attrs          = identify(temp_object)
        opts[:width]   ||= attrs[:width]
        opts[:height]  ||= attrs[:height]
      end

      opts[:gravity] ||= 'c'

      opts[:resize]  = "#{opts[:width]}x#{opts[:height]}^^"
      crop_args opts
    end

    def resized_dimensions width, height, geometry
      new_width, new_height =
        case geometry
        when /^(\d+)%$/
          scale = $1.to_f
          [round_off(width * scale), round_off(height * scale)]
        when /^(\d+)%?x(\d+)%$/, /^(\d+)%x(\d+)%?$/
          x_scale = $1.to_f
          y_scale = $2.to_f
          [round_off(width * x_scale), round_off(height * y_scale)]
        when /^(\d+)x?$/
          new_height =  ($1.to_f * height) / width
          [$1.to_i, round_off(new_height)]
        when /^x(\d+)$/
          new_width = ($1.to_f * width) / height
          [round_off(new_width), $1.to_i]
        when /^(\d+)x(\d+)$/
          resized_dimensions_preserving_aspect_ratio width, height, $1, $2, :max
        when /^(\d+)x(\d+)\^$/
          resized_dimensions_preserving_aspect_ratio width, height, $1, $2, :min
        when /^(\d+)x(\d+)!$/
          [$1, $2]
        when /^(\d+)?x?(\d+)?>$/
          new_width = $1.nil? ? nil : $1.to_i
          new_height = $2.nil? ? nil : $2.to_i

          if new_width.nil?
            
            if new_height.nil?
              raise "unrecognized argument for -resize: #{geometry}"
            elsif height > new_height
              [round_off((width.to_f * new_height) / height), new_height]
            else
              [width, height]
            end
            
          elsif new_height.nil?
            
            if width > new_width
              [new_width, round_off((height.to_f * new_width) / width)]
            else
              [width, height]
            end
          
          elsif (width > new_width || height > new_height)
            resized_dimensions_preserving_aspect_ratio width, height, new_width, new_height, :max
          else
            [width, height]
          end
        when /^(\d+)x(\d+)<$/
          new_width = $1.to_i
          new_height = $2.to_i
          if (width > new_width && height > new_height)
            resized_dimensions_preserving_aspect_ratio width, height, new_width, new_height, :max
          else
            [width, height]
          end
        when /^(\d+)@$/
          # Todo: check that imagemagick rounds off the same way 
          new_area = $1.to_f
          new_width = Math.sqrt(new_area * (width.to_f / height))
          new_height = new_area / new_width
          [round_off(new_width), round_off(new_height)]
        else
          raise "unrecognized argument for -resize: #{geometry}"
        end
      { :width => new_width, :height => new_height }
    end

    # new_width and new_height can be String, Float, or Fixnum
    def resized_dimensions_preserving_aspect_ratio width, height, new_width, new_height, max_or_min = :max
      raise unless [:max, :min].include? max_or_min
      aspect_ratio = width.to_f / height

      height_for_new_width = new_width.to_f / aspect_ratio
      new_height = new_height.to_f
      
      if (max_or_min == :max && height_for_new_width < new_height) ||
          (max_or_min == :min && height_for_new_width > new_height)
        [new_width.to_i, round_off(height_for_new_width)]
      else
        [round_off(new_height * aspect_ratio), new_height.to_i]
      end
    end

    def round_off float
      (float + 0.5).to_i
    end

    extend self
    
  end
end
