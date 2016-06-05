#
# Be sure to run `pod lib lint SettingsBox.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SettingsBox'
  s.version          = '0.1.0'
  s.summary          = 'Persists all your settings easier than ever'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SettingsBox is a convenient way to save your app settings (primitives and objects) and get them automatically restored when the app launches next time.
                       DESC

  s.homepage         = 'https://github.com/alexburtnik/SettingsBox'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alex Burtnik' => 'alexburtnik@gmail.com' }
  s.source           = { :git => 'https://github.com/alexburtnik/SettingsBox.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SettingsBox/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SettingsBox' => ['SettingsBox/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
