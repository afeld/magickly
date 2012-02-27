require 'spec_helper'

describe Magickly::CollapsingConvert do

  before do
    @image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
    @image = Magickly.dragonfly.fetch_file(@image_path)
  end

  describe "for resize" do

    before do
      @factory = Magickly.get_convert_factory(:resize)
    end
    
    describe "of x200" do

      before do
        @convert = @factory.new_convert @image, "x200"
      end

      it "#current_args should return -resize x200" do
        @convert.current_args.should eq("-resize x200")
      end

      it "#execute should succeed" do
        @convert.execute
      end
      
    end
  end

  describe "for brightness_contrast" do

    before { @factory = Magickly.get_convert_factory :brightness_contrast }

    describe "of an empty string" do
      before { @convert = @factory.new_convert @image, "" }

      it "#current_args should raise an error" do
        expect { @convert.current_args }.to raise_error(ArgumentError)
      end
    end

    describe "of 10x10" do
      before { @convert = @factory.new_convert @image, "10x10" }
      
      it "#current_args should return -brightness-contrast 10x10" do
        @convert.current_args.should eq("-brightness-contrast 10x10")
      end

      it "#execute should succeed" do
        @convert.execute
      end
    end

    describe "of -80x-80" do
      before { @convert = @factory.new_convert @image, "-80x-80" }
      
      it "#current_args should return -brightness-contrast -80x-80" do
        @convert.current_args.should eq("-brightness-contrast -80x-80")
      end

      it "#execute should succeed" do
        @convert.execute
      end
    end
  end

  describe "for tilt_shift" do

    before { @factory = Magickly.get_convert_factory :tilt_shift }

    describe "of an empty string" do
      before { @convert = @factory.new_convert @image, "" }

      it "#execute should raise an error" do
        expect { @convert.execute }.to raise_error(ArgumentError)
      end
    end

    describe "of 2,-1,0.5" do
      before { @convert = @factory.new_convert @image, "2,-1,0.5" }
      
      it "#execute should succeed" do
        @convert.execute
      end
    end
  end

  describe "for lomo" do

    before { @factory = Magickly.get_convert_factory :lomo }

    describe "of an empty string" do
      before { @convert = @factory.new_convert @image, "" }

      it "#execute should raise an error" do
        expect { @convert.execute }.to raise_error(ArgumentError)
      end
    end

    describe "of true" do
      before { @convert = @factory.new_convert @image, "true" }
      
      it "#execute should succeed" do
        @convert.execute
      end
    end
    
    describe "of 100,120" do
      before { @convert = @factory.new_convert @image, "100,120" }
      
      it "#execute should succeed" do
        @convert.execute
      end
    end

    describe "of negative values" do
      before { @convert = @factory.new_convert @image, "-80,-80" }

      it "#execute should raise an error" do
        expect { @convert.execute }.to raise_error(ArgumentError)
      end
    end
    
  end
  
  
end
