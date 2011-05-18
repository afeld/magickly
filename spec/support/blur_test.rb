(5..10).each do |rad|
  print "radius: #{rad}   "
  start = Time.now
  %x[
    convert beijing_contrast.jpeg \\( +clone -sparse-color Barycentric '0,0 black 0,%h white' -function polynomial 4,-4,1 \\) -compose Blur -set option:compose:args #{rad} -composite beijing_model#{rad}.jpg
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
