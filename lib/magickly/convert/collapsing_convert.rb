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
    #  force_format (Symbol): format to be forced regardless of original's format (identify unnecessary)
    #  need_format (Boolean): signals that an identify will be necessary to determine format
    def initialize image, options
      @image = image
      raise "must set image" unless @image
      @convert_args_generator, @identity_modifier, @previous, @value, @force_format, @need_format =
        options.values_at(:convert_args_generator, :identity_modifier, :previous, :value, :force_format, :need_format)
      @notes = {}
    end

    def current_args
      args = @previous.nil? ? "" : "#{@previous.current_args} "
      args += @convert_args_generator.call(@value, self)
      args
    end

    def execute
      args = current_args
      puts args
      @image.convert args, format
    end

    def format
      if @force_format
        @force_format
      elsif @need_format
        post_identify[:format]
      elsif @previous
        @previous.format
      else
        # Assume format is not changing (prevents unnecessary identify)
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

      @post_identity
    end


  end
  
end
