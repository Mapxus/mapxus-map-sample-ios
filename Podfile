# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'MapxusMapSample' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  # Pods for MapxusMapSample
  pod 'MapxusBaseSDK'#, :path => '../mapxus-base-sdk-ios'
  pod 'MapxusMapSDK'#, :path => '../mapxus-map-sdk-ios'
  pod 'MapxusVisualSDK'#, :path => '../mapxus-visual-sdk-ios'
  pod 'MapxusComponentKit'#, :path => '../mapxus-component-kit-ios'


  pod 'ProgressHUD'
  pod 'IQKeyboardManager'
  #  pod 'MLeaksFinder'
  
  target 'MapxusMapSampleTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'MapxusMapSampleUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
  end
end

