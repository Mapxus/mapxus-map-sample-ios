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

#bitcode enable
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
            
            config.build_settings['ENABLE_BITCODE'] = 'YES'
            
            if config.name == 'Release'
                config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
                else
                config.build_settings['BITCODE_GENERATION_MODE'] = 'marker'
            end
            
            cflags = config.build_settings['OTHER_CFLAGS'] || ['$(inherited)']
            
            if config.name == 'Release'
                cflags << '-fembed-bitcode'
                else
                cflags << '-fembed-bitcode-marker'
            end
            
            config.build_settings['OTHER_CFLAGS'] = cflags
        end
    end
end

