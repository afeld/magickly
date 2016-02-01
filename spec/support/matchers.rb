RSpec::Matchers.define :have_width do |expected|
  match do |file|
    expect(FastImage.size(file)[0]).to eq(expected)
  end
end

RSpec::Matchers.define :have_height do |expected|
  match do |file|
    expect(FastImage.size(file)[1]).to eq(expected)
  end
end
