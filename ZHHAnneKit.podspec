Pod::Spec.new do |s|
  s.name             = 'ZHHAnneKit'
  s.version          = '0.1.0'
  s.summary          = '一套实用的分类与工具库，提升开发效率。'
  s.description      = <<-DESC
  ZHHAnneKit 提供了一系列常用的分类和工具类，涵盖 Foundation 和 UIKit 等模块，旨在简化日常开发工作，提高代码复用性和开发效率。
  DESC
  s.homepage         = 'https://github.com/yue5yueliang/ZHHAnneKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHAnneKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'

  # 公共头文件
  s.public_header_files = 'ZHHAnneKit/Classes/**/*.h'
  s.source_files = 'ZHHAnneKit/Classes/**/*.{h,m}'

  ### Foundation 子模块 ###
  s.subspec 'Foundation' do |foundation|
#    foundation.public_header_files = 'ZHHAnneKit/Classes/Foundation/**/*.h'
    foundation.source_files = 'ZHHAnneKit/Classes/Foundation/**/*.{h,m}'

    %w[
      NSArray NSAttributedString NSBundle NSData NSDate NSDecimalNumber NSDictionary
      NSException NSFileManager NSIndexPath NSNotification NSNotificationCenter
      NSNumber NSObject NSString NSTimer
    ].each do |subspec_name|
      foundation.subspec subspec_name do |subspec|
#        subspec.public_header_files = "ZHHAnneKit/Classes/Foundation/#{subspec_name}/*.h"
        subspec.source_files = "ZHHAnneKit/Classes/Foundation/#{subspec_name}/*.{h,m}"
      end
    end
  end

  ### UIKit 子模块 ###
  s.subspec 'UIKit' do |uikit|
#    uikit.public_header_files = 'ZHHAnneKit/Classes/UIKit/**/*.h'
    uikit.source_files = 'ZHHAnneKit/Classes/UIKit/**/*.{h,m}'
    uikit.frameworks = 'UIKit'

    %w[
      UIApplication UIColor UIControl UIImageView UILabel UINavigationController
      UINavigationItem UISlider UISplitViewController UITableView UITextField
      UITextView UIView UIViewController UIWindow
    ].each do |subspec_name|
      uikit.subspec subspec_name do |subspec|
#        subspec.public_header_files = "ZHHAnneKit/Classes/UIKit/#{subspec_name}/*.h"
        subspec.source_files = "ZHHAnneKit/Classes/UIKit/#{subspec_name}/*.{h,m}"
      end
    end

    # 特定依赖关系
    uikit.subspec 'UIBarButtonItem' do |barbuttonitem|
#      barbuttonitem.public_header_files = "ZHHAnneKit/Classes/UIKit/UIBarButtonItem/*.h"
      barbuttonitem.source_files = "ZHHAnneKit/Classes/UIKit/UIBarButtonItem/*.{h,m}"
      barbuttonitem.dependency 'ZHHAnneKit/UIKit/UIColor' # 引入 UIColor+ZHHUtilities.h 的依赖
      barbuttonitem.dependency 'ZHHAnneKit/UIKit/UIView'  # 引入 UIView+ZHHFrame.h 的依赖
    end

    uikit.subspec 'UIButton' do |button|
#      button.public_header_files = "ZHHAnneKit/Classes/UIKit/UIButton/*.h" # 公开的头文件路径
      button.source_files = "ZHHAnneKit/Classes/UIKit/UIButton/*.{h,m}"    # 源文件路径
      button.dependency 'ZHHAnneKit/UIKit/UIImage'  # 声明对 UIImage 模块的依赖
    end

    uikit.subspec 'UIDevice' do |device|
#      device.public_header_files = "ZHHAnneKit/Classes/UIKit/UIDevice/*.h" # 公开的头文件路径
      device.source_files = "ZHHAnneKit/Classes/UIKit/UIDevice/*.{h,m}"    # 源文件路径
      device.dependency 'ZHHAnneKit/CommonTools'
    end

    uikit.subspec 'UIImage' do |image|
#      image.public_header_files = "ZHHAnneKit/Classes/UIKit/UIImage/*.h" # 公开的头文件路径
      image.source_files = "ZHHAnneKit/Classes/UIKit/UIImage/*.{h,m}"    # 源文件路径
      image.dependency 'ZHHAnneKit/UIKit/UIColor'
    end
  end

  ### QuartzCore 子模块 ###
  s.subspec 'QuartzCore' do |quartzcore|
#    quartzcore.public_header_files = 'ZHHAnneKit/Classes/QuartzCore/**/*.h'
    quartzcore.source_files = 'ZHHAnneKit/Classes/QuartzCore/**/*.{h,m}'

    %w[CALayer CATransaction].each do |subspec_name|
      quartzcore.subspec subspec_name do |subspec|
#        subspec.public_header_files = "ZHHAnneKit/Classes/QuartzCore/#{subspec_name}/*.h"
        subspec.source_files = "ZHHAnneKit/Classes/QuartzCore/#{subspec_name}/*.{h,m}"
      end
    end
  end

  ### CommonTools 子模块 ###
  s.subspec 'CommonTools' do |commontools|
#    commontools.public_header_files = 'ZHHAnneKit/Classes/CommonTools/**/*.h'
    commontools.source_files = 'ZHHAnneKit/Classes/CommonTools/**/*.{h,m}'
  end
end
