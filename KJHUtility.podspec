Pod::Spec.new do |s|
  s.name         = "KJHUtility"
  s.version      = "0.2"
  s.summary      = "A small set of random utilities written in Swift."
  s.homepage     = "https://github.com/KieranHarper/KJHUtility"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Kieran Harper" => "kieranjharper@gmail.com" }
  s.social_media_url   = "https://twitter.com/KieranTheTwit"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/KieranHarper/KJHUtility.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
