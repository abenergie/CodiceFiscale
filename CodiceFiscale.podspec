#
# Be sure to run `pod lib lint CodiceFiscale.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CodiceFiscale'
  s.version          = '0.1.5'
  s.summary          = 'Una semplice libreria per iOS scritta in swift che ti permette di calcolare il codice fiscale.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Una semplice libreria per iOS scritta in swift che ti permette di calcolare il codice fiscale. bla bla bla bla
                       DESC

  s.homepage         = 'https://github.com/abenergie/CodiceFiscale'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mo3bius' => 'luigiaiello97@gmail.com' }
  s.source           = { :git => 'https://github.com/abenergie/CodiceFiscale.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.abenergie.it'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'CodiceFiscale/Classes/**/*'
  s.resources = 'CodiceFiscale/Assets/*.{json}'
  s.resource_bundles = {
      'CodiceFiscale' => ['CodiceFiscale/Assets/*']
  }


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
