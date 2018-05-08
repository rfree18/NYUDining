source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.2'
use_frameworks!

target 'NYUDining' do

    pod 'Firebase'
    pod 'Firebase/Database'
    pod 'GoogleMaps'
    pod 'PKHUD', :git => 'https://github.com/pkluz/PKHUD.git', :branch => 'release/swift4'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'PureLayout'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
