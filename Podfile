platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!     # 屏蔽pod中告警
require "fileutils"


target 'ZLGiteeClient' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'ZLBaseUI', :git => 'https://github.com/ExistOrLive/ZLBaseUI.git', :tag => '1.2.1'
  #pod 'ZLBaseUI', :path => "../ZLBaseUI"

 pod 'ZLBaseExtension', :git => "https://github.com/ExistOrLive/ZLBaseExtension.git", :tag => '1.2.0'
 #pod 'ZLBaseExtension', :path => "../ZLBaseExtension"
 
 pod 'ZLUIUtilities', :git => "https://github.com/ExistOrLive/ZLUIUtilities.git"
 #pod 'ZLUIUtilities', :path => "../ZLUIUtilities"

# 弹出框 弹出菜单
pod 'FWPopupView'
# 刷新控件
pod 'MJRefresh'
# 转圈控件
pod 'MBProgressHUD'
# ToastView https://github.com/scalessec/Toast-Swift
pod 'Toast'
# pageView控件 https://github.com/pujiaxin33/JXSegmentedView
pod 'JXSegmentedView'
# 键盘 https://github.com/hackiftekhar/IQKeyboardManager
pod 'IQKeyboardManager'
# 图表
#pod 'ChartsRealm'
pod 'Charts'
#下载图片
pod 'SDWebImage', '~> 5.0.0'
# AutoLayout
pod 'Masonry'
pod 'SnapKit', '~> 4.0.0'

pod 'YYText'

# 弹出框容器
pod 'FFPopup'

pod 'LookinServer', :configurations => ['Debug']
pod 'DoraemonKit/Core', '~> 2.0.0', :configurations => ['Debug']
pod 'DoraemonKit/WithLogger', '~> 2.0.0', :configurations => ['Debug']
#pod 'DoraemonKit/WithGPS', '~> 2.0.0', :configurations => ['Debug']
pod 'DoraemonKit/WithMLeaksFinder', '2.0.0', :configurations => ['Debug']


# Rx
pod 'RxSwift'
pod 'RxCocoa'
pod 'RxRelay'

# Http Network
pod 'Moya'

pod 'HandyJSON'

end

post_install do |installer|
    ## fix oclint issue : one compiler command contains multiple jobs
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = "NO"
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
            end
        end
    end
    ## Fix for XCode 12.5
    find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm","layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
end

def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      FileUtils.chmod("+w", name) #add
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end

