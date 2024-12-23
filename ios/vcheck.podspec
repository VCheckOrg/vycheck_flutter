#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint vcheck.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'vcheck'
  s.version          = '1.4.12'
  s.summary          = 'VCheck for Flutter podspec'
  s.description      = <<-DESC
  VCheck for Flutter podspec.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  
  s.dependency 'Flutter'

  s.dependency 'VCheckSDK', '~> 1.4.12'

  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
