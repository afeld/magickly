module Magickly

  @@convert_factories = {}

  class << self

    def add_convert_factory key, &block
      @@convert_factories[key] = CollapsingConvertFactory.new &block
    end

    def add_simple_convert_factory(key, convert_args, takes_arg = false,
                                   arg_rx = nil, bad_arg_msg = nil)
      add_convert_factory key do |c|
        c.convert_args do |value, identifier|
          if takes_arg
            if arg_rx && value !~ arg_rx
              bad_arg_msg ||= "Bad Argument"
              raise ArgumentError, bad_arg_msg
            else
              "#{convert_args} #{value}"
            end
          else
            convert_args
          end
        end
      end
    end
    
    def get_convert_factory key
      @@convert_factories[key]
    end

  end

  class CollapsingConvertFactory

    attr_accessor :convert_args_generator, :force_format, :identity_modifier, :need_format

    def configure
      yield self if block_given?
    end

    def convert_args &block
      @convert_args_generator = block
    end

    def identity &block
      @identity_modifier = block
    end

    def initialize &block
      configure &block
    end

    def new_convert image, value, previous = nil
      CollapsingConvert.new(image,
                            :convert_args_generator => @convert_args_generator,
                            :identity_modifier => @identity_modifier,
                            :value => value,
                            :previous => previous,
                            :force_format => @force_format,
                            :need_format => @need_format)
    end

  end
end


                            
      

      
        
