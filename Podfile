
 platform :ios, '15.0'
use_frameworks!

target 'MyFirebase' do
  # Comment the next line if you don't want to use dynamic frameworks
  
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'SwiftCheckboxDialog'
  pod 'DropDown'

end
target 'LoginTests' do
  pod 'SnapshotTesting', '~> 1.9.0'
end
target 'UsersTests' do
  inherit! :search_paths
  pod 'SnapshotTesting', '~> 1.9.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
  end

