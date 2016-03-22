# use_frameworks!

xcodeproj 'VimeoNetworkingExample-iOS/VimeoNetworkingExample-iOS.xcodeproj'

workspace 'VimeoNetworking'

def shared_pods
    pod 'VIMObjectMapper', '6.0.0'
    pod 'VIMNetworking/Model', '6.0.0'
    pod 'AFNetworking', '2.6.3'
end

target 'VimeoNetworkingExample-iOS' do
	shared_pods

	xcodeproj 'VimeoNetworkingExample-iOS/VimeoNetworkingExample-iOS.xcodeproj'
end

target 'VimeoNetworkingExample-iOSTests' do
	shared_pods
end

target 'VimeoNetworkingExample-iOSUITests' do
	shared_pods
end

