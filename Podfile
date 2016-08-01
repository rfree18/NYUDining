source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'NYUDining' do

    pod 'Firebase'
    pod 'Firebase/Database'
    pod 'Firebase/Messaging'
    
    pod 'MBProgressHUD', '~> 0.9.2'
    pod 'Alamofire', '~> 3.4'
    
    pod 'Fabric'
    pod 'Crashlytics'
    
    pod 'PureLayout'
    pod 'SwiftyJSON'
    
    pod 'FBSDKCoreKit'
    pod  'FBSDKLoginKit'
    pod 'FBSDKShareKit'
    
    pod 'QuickBlox'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end 
end