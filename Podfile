# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# Commencing with version v6.5.0, the Mapxus SDKs along with their dependent libraries will be transitioned to a
# private repository located at 'https://github.com/Mapxus/mapxusSpecs.git'. To guarantee the successful download
# of the correct versions of the Mapxus SDKs and their dependencies, we kindly request you to prioritize this
# private repository address above all other repository download addresses.
source 'https://github.com/Mapxus/mapxusSpecs.git'
source 'https://cdn.cocoapods.org/'

target 'MapxusMapSample' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  # Pods for MapxusMapSample
  pod 'MapxusBaseSDK', '6.6.0'#:path => '../mapxus-base-sdk-ios'
  pod 'MapxusMapSDK', '6.6.0'#:path => '../mapxus-map-sdk-ios'
  pod 'MapxusVisualSDK', '6.6.0'#:path => '../mapxus-visual-sdk-ios'
  pod 'MapxusComponentKit', '6.6.0'#:path => '../mapxus-component-kit-ios'


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

