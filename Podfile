use_frameworks!

workspace 'VimeoNetworking'
project 'VimeoNetworkingExample-iOS/VimeoNetworkingExample-iOS.xcodeproj'

def shared_pods
	pod 'AFNetworking', '3.1.0'
  pod 'VimeoNetworking', :path => '../VimeoNetworking'
end

target 'VimeoNetworkingExample-iOS' do
  shared_pods
	platform :ios, '8.0'

  target 'VimeoNetworkingExample-iOSTests' do
    inherit! :search_paths
	end
end

target 'VimeoNetworkingExample-tvOS' do
  shared_pods
	platform :tvos, '10.0'

  target 'VimeoNetworkingExample-tvOSTests' do
    inherit! :search_paths
	end
end
