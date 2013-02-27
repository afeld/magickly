require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec
task :test => :spec

desc "Runs a performance test of different sigma values to tilt_shift"
task :blur_test do
  file = File.join(File.dirname(__FILE__), 'spec', 'support', 'imagemagick.png')
  dir = File.join(File.dirname(__FILE__), 'test_output')
  Dir.mkdir(dir)
  
  (5..10).each do |sigma|
    print "sigma: #{sigma}   "
    out_file = File.join(dir, "blur_test-#{sigma}.png")
    start = Time.now
    %x[
      convert #{file} \\( +clone -sparse-color Barycentric '0,0 black 0,%h white' -function polynomial 4,-4,1 \\) -compose Blur -set option:compose:args #{sigma} -composite #{out_file}
    ]
    elapsed = Time.now - start
    puts "time: #{elapsed}"
  end

  # RESULTS:
  # 
  # radius: 5   time: 2.090919
  # radius: 6   time: 2.855877
  # radius: 7   time: 3.800624
  # radius: 8   time: 4.872925
  # radius: 9   time: 6.213271
  # radius: 10   time: 7.62648
end
