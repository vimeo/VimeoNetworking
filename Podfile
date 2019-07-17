use_frameworks!
inhibit_all_warnings!
platform :ios, '10.3'     

workspace 'VimeoNetworking'
project 'VimeoNetworking.xcodeproj'

def shared_pods
    pod 'AFNetworking', '3.1.0'
    pod 'SwiftLint', '0.25.1'
end

def test_pods
    pod 'OHHTTPStubs/Swift', '8.0.0'
end

target 'VimeoNetworking-tvOS' do  
    platform :tvos, '9.0'       
    shared_pods
    target 'VimeoNetworking-tvOSTests' do
        test_pods
    end
end

target 'VimeoNetworking-iOS' do   
    platform :ios, '10.3'     
    shared_pods
    target 'VimeoNetworking-iOSTests' do
        pod 'VimeoTestsSupport', :git => 'git@github.vimeows.com:MobileApps/VimeoTestsSupport.git', :branch => 'master'
        test_pods
    end
end

target 'VimeoNetworking-macOS' do  
    platform :osx, '10.11'      
    shared_pods
    target 'VimeoNetworking-macOSTests' do
        test_pods
    end
end

target 'Example' do     
    shared_pods
end
