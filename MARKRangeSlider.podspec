Pod::Spec.new do |s|
  s.name             = "MARKRangeSlider"
  s.version          = "0.2.0"
  s.summary          = "An easy-to-use multitouch range slider"
  s.homepage         = "https://github.com/markvaldy/MARKRangeSlider"
  s.license          = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author           = { "Vadym Markov" => "impressionwave@gmail.com" }
  s.social_media_url = 'https://twitter.com/markvaldy'
  s.source           = {
    :git => "https://github.com/markvaldy/MARKRangeSlider.git",
    :tag => s.version.to_s
  }

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.frameworks = 'UIKit'

  s.source_files = 'Source/**/*.{h,m}'
  s.resources = 'Resources/**/*'
end
