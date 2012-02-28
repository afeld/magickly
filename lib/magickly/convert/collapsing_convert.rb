module Magickly

  class CollapsingConvert

    # Hack: include these modules to get Utils#identify() 
    include Dragonfly::Configurable
    include Dragonfly::ImageMagick::Utils

    attr_reader :image
    attr_accessor :notes

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
      @notes = {}
    end

    def current_args
      args = @previous.nil? ? "" : "#{@previous.current_args} "
      args += @convert_args_generator.call(@value, self)
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

    def pre_identify
      return @pre_identity if @pre_identity
      if @previous.nil?
        # We are the first convert.  We need to get the
        # identity data directly from the source image
        raise "Neither previous nor image set" if @image.nil?
        @pre_identity = identify @image
      else
        @pre_identity = @previous.post_identify
      end
      @pre_identity
    end

    protected
    
    def post_identify
      return @post_identity if @post_identify

      if @identity_modifier
        @post_identity = @identity_modifier.call @value, self
      else
        # No identity changes for this convert
        @post_identity = pre_identify
      end

      @post_identity = @post_identity.merge :format => @format if @format
      
      @post_identity
    end


  end
  
end
