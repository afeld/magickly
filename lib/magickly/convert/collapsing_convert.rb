module Magickly

  class CollapsingConvert

    # Hack: include these modules to get Utils#identify() 
    include Dragonfly::Configurable
    include Dragonfly::ImageMagick::Utils

    # image: dragonfly image
    # options:
    #  convert_args_generator (Proc)
    #  identity_modifier (Proc)
    #  previous (CollapsingConvert)
    #  value (String)
    def initialize image, options
      @image = image
      raise "must set image" unless @image
      @convert_args_generator, @format, @identity_modifier, @previous, @value =
        options.values_at(:convert_args_generator, :format, :identity_modifier,
                          :previous, :value)
    end

    def current_args
      args = @previous.nil? ? "" : "#{@previous.current_args} "
      args += @convert_args_generator.call(@value, lambda { self.pre_convert_identify })
      args
    end

    def execute
      @image.convert current_args, format
    end

    def format
      if @format
        @format
      elsif @previous
        @previous.format
      else
        nil
      end
    end

    def post_convert_identify
      return @post_convert_identity if @post_convert_identify

      if @identity_modifier
        @post_convert_identity = @identity_modifier.call @value, pre_convert_identify
      else
        # No identity changes for this convert
        @post_convert_identity = pre_convert_identify
      end

      @post_convert_identity = @post_convert_identity.merge :format => @format
      
      @post_convert_identity
    end

    def pre_convert_identify
      return @pre_convert_identity if @pre_convert_identity
      if @previous.nil?
        # We are the first convert.  We need to get the
        # identity data directly from the source image
        raise "Neither previous nor image set" if @image.nil?
        @pre_convert_identity = identify @image
      else
        @pre_convert_identity = @previous.post_convert_identify
      end
      @pre_convert_identity
    end

  end
  
end
