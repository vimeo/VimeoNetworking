Pod::Spec.new do |s|

  s.name                    = "VimeoNetworking"
  s.version                 = "5.0.0"
  s.summary                 = "A library for interacting with the Vimeo API."
  s.description             = "An iOS/tvOS library for interacting with the Vimeo API."
  s.homepage                = "https://github.com/vimeo/VimeoNetworking"
  s.license                 = { :type => "MIT", :file => "LICENSE" }
  s.authors                 = { "Gavin King" => "gavin@vimeo.com",
                              "Nicole Lehrer" => "nicole@vimeo.com",
                              "Mike Westendorf" => "mikew@vimeo.com",
                              "Jason Hawkins" => "jasonh@vimeo.com",
                              "Jennifer Lim" => "jennifer@vimeo.com",
                              "Van Nguyen" => "van@vimeo.com",
                              "Freddy Kellison-Linn" => "freddyk@vimeo.com>"}

  s.social_media_url        = "http://twitter.com/vimeo"
  s.ios.deployment_target   = "10.3"
  s.tvos.deployment_target  = "10.0"
  s.osx.deployment_target   = "10.11"
  
  s.source                  = { :git => "https://github.com/vimeo/VimeoNetworking.git", :tag => s.version.to_s }
  
  s.source_files            = "Sources/Shared/**/*.{h,m,swift}"
  s.ios.source_files        = "Sources/iOS/**/*.{h,m,swift}", "Sources/iOS+tvOS/**/*.{h,m,swift}"
  s.tvos.source_files       = "Sources/tvOS/**/*.{h,m,swift}", "Sources/iOS+tvOS/**/*.{h,m,swift}"
  s.osx.source_files        = "Sources/macOS/**/*.{h,m,swift}"
    
  s.swift_version           = "5.0"

  s.resources               = "Sources/Resources/**/*.*"
  s.frameworks              = "Foundation"

  s.test_spec 'Tests' do |test_spec|

    test_spec.source_files            = "Tests/Shared/**/*.{h,m,swift}"
    test_spec.ios.source_files        = "Tests/iOS/**/*.{h,m,swift}"
    test_spec.tvos.source_files       = "Tests/tvOS/**/*.{h,m,swift}"
    test_spec.osx.source_files        = "Tests/macOS/**/*.{h,m,swift}"
    test_spec.resources               = "Tests/Fixtures/**/*.*"        
    
    test_spec.dependency 'OHHTTPStubs/Swift', '8.0.0'
  end  

end
