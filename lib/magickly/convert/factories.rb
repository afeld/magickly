module Magickly

  extend Magickly::ConvertHelpers

  LOMO_MASK_PATH = File.join(File.dirname(__FILE__), 'images', 'lomo_mask.png')

  add_simple_convert_factory :auto_orient, "-auto-orient"

  add_simple_convert_factory(:brightness_contrast,
                             "-brightness-contrast",
                             true,
                             /^-?\d+%?(x-?\d+%?)?$/,
                             "argument must be of the format '<int>[%]x<int>[%]'")

  add_convert_factory :color_palette_swatch do |c|
    c.convert_args do |count, convert|
      count = Magickly::DEFAULT_PALETTE_COLOR_COUNT if count == 'true'
      "-resize 600x600 -colors #{count} -unique-colors -scale 10000%"
    end

    c.identity do |count, convert|
      convert.pre_identify.merge :width => 600, :height => 600, :format => :gif
    end

    c.force_format = :gif
  end

  # thanks to http://www.photoshopsupport.com/tutorials/or/cross-processing.html
  add_simple_convert_factory :cross_process, "-channel Red -sigmoidal-contrast 6,50% -channel Blue -level 25%\\! -channel Green -sigmoidal-contrast 5,45% \\( +clone +matte -fill yellow -colorize 4% \\) -compose overlay -composite"

  add_simple_convert_factory :flip, "-flip"

  add_simple_convert_factory :flop, "-flop"

  # thanks to Fred Weinhaus (http://www.fmwconcepts.com/imagemagick)
  add_convert_factory :glow do |c|
    c.convert_args do |value, convert|
      if value == 'true'
        amount = 1.2
        softening = 20
      elsif value =~ /^(\d+\.\d+?),(\d+)$/ && $1.to_f >= 1.0 && $2.to_i >= 0
        amount = $1
        softening = $2
      else
        raise ArgumentError, "args must be of the form <amount(float)>,<softening(int)>"
      end
      
      "\\( +clone -evaluate multiply #{amount} -blur 0x#{softening} \\) -compose plus -composite"
    end
  end

  add_simple_convert_factory :grayscale, "-colorspace Gray"

  add_simple_convert_factory :greyscale, "-colorspace Gray"

  # thanks to http://www.melissaevans.com/tutorials/pop-art-inspired-by-lichtenstein
  add_convert_factory :halftone do |c|
    c.convert_args do |threshold, convert|
      threshold = 50 if threshold == 'true'
      "-white-threshold #{threshold.to_i}% -gaussian-blur 2 -ordered-dither 8x1"
    end
  end

  # thanks to Jesse Chan-Norris - http://jcn.me/
  add_simple_convert_factory :jcn, "-colorspace Gray -white-threshold 99% -gaussian-blur 2 -ordered-dither 8x1"

  ## thanks to https://github.com/soveran/lomo
  add_convert_factory :lomo do |c|
    c.convert_args do |modulate_params, convert|
      if modulate_params == 'true'
        modulate_params = '100,150'
      elsif modulate_params !~ /^\d+,\d+$/
        raise ArgumentError, "modulate_params must be of the format '<int>,<int>'"
      end

      width, height = convert.pre_identify.values_at :width, :height
      
      "\\( +clone -unsharp 1 -contrast -contrast -modulate #{modulate_params} \\( #{LOMO_MASK_PATH} -resize #{width}x#{height}\\! \\) -compose overlay -composite \\) -compose multiply -composite"
    end
  end

  add_convert_factory :resize do |c|
    c.convert_args do |geometry, convert|
      "-resize #{geometry}"
    end

    c.identity do |geometry, convert|
      identity = convert.pre_identify
      identity.merge resized_dimensions(identity[:width], identity[:height], geometry)
    end
  end

  add_simple_convert_factory :resize_with_blur, "-filter Gaussian -resize", true

  add_simple_convert_factory :rotate, "-rotate", true

  add_convert_factory :saturation do |c|
    c.convert_args do |percentage, convert|
      raise ArgumentError, "percentage must be a positive integer" unless percentage =~ /^\d+$/
      "-modulate 100,#{percentage}"
    end
  end

  # Adapted from dragonfly
  add_convert_factory :thumb do |c|
    c.convert_args do |geometry, convert|
      case geometry
      when Dragonfly::ImageMagick::Processor::RESIZE_GEOMETRY
        "-resize #{geometry}"
      when Dragonfly::ImageMagick::Processor::CROPPED_RESIZE_GEOMETRY
        resize_and_crop_args :width => $1, :height => $2, :gravity => $3
      when Dragonfly::ImageMagick::Processor::CROP_GEOMETRY
        crop_args(
                  :width => $1,
                  :height => $2,
                  :x => $3,
                  :y => $4,
                  :gravity => $5
                  )
      else raise ArgumentError, "Didn't recognise the geometry string #{geometry}"
      end
    end

    c.identity do |geometry, convert|
      prev_identity = convert.pre_identify
      width, height = prev_identity.values_at :width, :height
      case geometry
      when Dragonfly::ImageMagick::Processor::RESIZE_GEOMETRY
        current_identity.merge resized_dimensions(width, height, value)
      when Dragonfly::ImageMagick::Processor::CROPPED_RESIZE_GEOMETRY, Dragonfly::ImageMagick::Processor::CROP_GEOMETRY
        current_identity.merge :width => $1, :height => $2
      else raise ArgumentError, "Didn't recognise the geometry string #{geometry}"
      end
    end
    
  end

  add_convert_factory :tilt_shift do |c|
    c.convert_args do |coefficients, convert|
      coefficients = '4,-4,1' if coefficients == 'true'
      raise ArgumentError, "coefficients must be of the format '<decimal>,<decimal>,<decimal>'" unless coefficients =~ /^(-?\d+(\.\d+)?,){2}-?\d+(\.\d+)?$/
    
      # note: can be made faster by decreasing sigma passed to option:compose:args
      "\\( +clone -sparse-color Barycentric '0,0 black 0,%h white' -function polynomial #{coefficients} \\) -compose Blur -set option:compose:args 8 -composite"
    end
  end

  # thanks to Fred Weinhaus (http://www.fmwconcepts.com/imagemagick)
  add_simple_convert_factory :two_color, "-background black -flatten +matte +dither -colors 2 -colorspace gray -contrast-stretch 0"
  
end
