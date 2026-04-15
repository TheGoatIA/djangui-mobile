Pod::Spec.new do |s|
  s.name         = 'SwiftTryCatch'
  s.version      = '1.0.2'
  s.summary      = 'Catches Objective-C exceptions in Swift.'
  s.description  = 'A small utility that allows Swift code to catch Objective-C exceptions.'
  s.homepage     = 'https://github.com/cfr/SwiftTryCatch'
  s.license      = { :type => 'MIT' }
  s.author       = { 'cfr' => 'cfr@me.com' }
  s.source       = { :path => '.' }
  s.source_files = '*.{h,m}'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
end
