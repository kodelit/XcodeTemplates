#
# Be sure to run `pod lib lint ___VARIABLE_podName___.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = '___VARIABLE_podName___'
s.version          = '0.1.0'
s.summary          = '___VARIABLE_summary___'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
___VARIABLE_description___
DESC

s.homepage         = 'https://github.com/___VARIABLE_userName___/___VARIABLE_podName___'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '___VARIABLE_userName___' => '___VARIABLE_email___' }
s.source           = { :git => 'https://github.com/___VARIABLE_userName___/___VARIABLE_podName___.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/___VARIABLE_userName___'

s.ios.deployment_target = '___VARIABLE_deploymentTarget___'

s.source_files = '___VARIABLE_podName___/**/*'

# s.resource_bundles = {
#   '___VARIABLE_podName___' => ['___VARIABLE_podName___/Assets/*.png']
# }

# s.public_header_files = '___VARIABLE_podName___/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
