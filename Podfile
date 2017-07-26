use_frameworks!

workspace 'VimeoNetworking'
project 'VimeoNetworkingExample-iOS/VimeoNetworkingExample-iOS.xcodeproj'

def shared_pods
	pod 'AFNetworking', '3.1.0'
    pod 'VimeoNetworking', :path => '../VimeoNetworking'
end

target 'VimeoNetworkingExample-iOS' do
    shared_pods

    target 'VimeoNetworkingExample-iOSTests' do
    	inherit! :search_paths
        pod 'OHHTTPStubs/Swift', '6.0.0'
	end
end

target 'VimeoNetworkingExample-tvOS' do
    shared_pods

    target 'VimeoNetworkingExample-tvOSTests' do
    	inherit! :search_paths
        pod 'OHHTTPStubs/Swift', '6.0.0'
	end
end
