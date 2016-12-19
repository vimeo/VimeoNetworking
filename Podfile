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
	end
end

target 'VimeoNetworkingtvOS' do
	shared_pods
	inherit! :search_paths
end

target 'VimeoNetworkingiOS' do
	shared_pods
	inherit! :search_paths
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = "2.3"
        end
    end
end