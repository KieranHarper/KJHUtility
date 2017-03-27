#
# Be sure to run `pod lib lint KJHUtility.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KJHUtility'
  s.version          = '0.1.1'
  s.summary          = 'A small set of random utilities written in Swift.'

  s.description      =  <<-DESC
                        This is a small set of random utilities written in Swift. I plan to add more stuff here as I move some of my general reusable classes into Swift. The idea is this collection is platform agnostic however I typically only work on iOS so whether they're good for macOS or linux would require some testing.
                        DESC

  s.homepage         = 'https://github.com/KieranHarper/KJHUtility'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kieran Harper' => 'kieranjharper@gmail.com' }
  s.source           = { :git => 'https://github.com/KieranHarper/KJHUtility.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'KJHUtility/Classes/**/*'
  s.frameworks = 'Foundation'
end
