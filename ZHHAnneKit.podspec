Pod::Spec.new do |s|
  s.name             = 'ZHHAnneKit'
  s.version          = '0.2.2'
  s.summary          = '一套高性能、安全可靠的 iOS 工具库，支持 iOS 13.0+'
  s.description      = <<-DESC
  ZHHAnneKit 是一套轻量化、实用的工具库，包含常用的分类和工具类，帮助开发者提升效率、优化代码复用性。
  
  主要特性：
  - 🚀 高性能：优化的内存管理和 Core Foundation 对象处理
  - 🛡️ 安全可靠：完善的参数验证和错误处理
  - 📱 iOS 13+：充分利用最新的 iOS 特性
  - 🎨 UI 增强：丰富的 UIView 扩展方法
  - 🔧 工具齐全：涵盖 Foundation、UIKit、QuartzCore、BadgeView 等模块
  - 📚 文档完善：详细的方法注释和使用示例
  
  涵盖模块：Foundation 扩展、UIKit 扩展、QuartzCore 动画、BadgeView 组件、CommonTools 工具等。
  DESC
  s.homepage         = 'https://github.com/yue5yueliang/ZHHAnneKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHAnneKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.frameworks = 'UIKit', 'Foundation', 'QuartzCore', 'CoreGraphics', 'AVFoundation', 'CoreLocation', 'Social'
  s.requires_arc = true

  s.default_subspec  = 'Core'
  s.subspec 'Core' do |core|
    # 公共头文件和源文件
    core.public_header_files = 'ZHHAnneKit/Classes/ZHHAnneKit.h'
    core.source_files = 'ZHHAnneKit/Classes/ZHHAnneKit.h'
    
    ### 一级目录 BadgeView ###
    core.subspec 'BadgeView' do |badgeview|
        badgeview.source_files = 'ZHHAnneKit/Classes/BadgeView/**/*.{h,m}'
    end
    
    ### 一级目录 CommonTools ###
    core.subspec 'CommonTools' do |commontools|
      
        # 公共头文件和源文件
        commontools.public_header_files = 'ZHHAnneKit/Classes/CommonTools/ZHHCommonKit.h'
        commontools.source_files = 'ZHHAnneKit/Classes/CommonTools/ZHHCommonKit.h'
        
        # 子模块
        commontools.subspec 'Common' do |subspec|
            subspec.source_files = 'ZHHAnneKit/Classes/CommonTools/Common/*.{h,m}'
        end

        commontools.subspec 'Countdown' do |subspec|
            subspec.source_files = 'ZHHAnneKit/Classes/CommonTools/Countdown/*.{h,m}'
        end

        commontools.subspec 'Hovering' do |subspec|
            subspec.source_files = 'ZHHAnneKit/Classes/CommonTools/Hovering/*.{h,m}'
            subspec.dependency 'ZHHAnneKit/Core/UIKit/UITableView'
        end

        commontools.subspec 'Keychain' do |subspec|
            subspec.source_files = 'ZHHAnneKit/Classes/CommonTools/Keychain/*.{h,m}'
        end
        
        commontools.subspec 'Permission' do |subspec|
            subspec.source_files = 'ZHHAnneKit/Classes/CommonTools/Permission/*.{h,m}'
            subspec.frameworks = 'CoreLocation'
        end
    end
    
    ### 一级目录 Foundation ###
    core.subspec 'Foundation' do |foundation|
      # 公共头文件和源文件
      foundation.public_header_files = 'ZHHAnneKit/Classes/Foundation/ZHHFoundation.h'
      foundation.source_files = 'ZHHAnneKit/Classes/Foundation/ZHHFoundation.h'
      
      # 子模块
      foundation.subspec 'NSArray' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSArray/*.{h,m}'
      end
      foundation.subspec 'NSAttributedString' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSAttributedString/*.{h,m}'
      end
      foundation.subspec 'NSBundle' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSBundle/*.{h,m}'
      end
      foundation.subspec 'NSData' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSData/*.{h,m}'
      end
      foundation.subspec 'NSDate' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSDate/*.{h,m}'
      end
      foundation.subspec 'NSDecimalNumber' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSDecimalNumber/*.{h,m}'
      end
      foundation.subspec 'NSDictionary' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSDictionary/*.{h,m}'
      end
      foundation.subspec 'NSException' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSException/*.{h,m}'
      end
      foundation.subspec 'NSFileManager' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSFileManager/*.{h,m}'
      end
      foundation.subspec 'NSIndexPath' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSIndexPath/*.{h,m}'
      end
      foundation.subspec 'NSNotification' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSNotification/*.{h,m}'
      end
      foundation.subspec 'NSNotificationCenter' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSNotificationCenter/*.{h,m}'
      end
      foundation.subspec 'NSNumber' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSNumber/*.{h,m}'
      end
      foundation.subspec 'NSObject' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSObject/*.{h,m}'
      end
      foundation.subspec 'NSShadow' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSShadow/*.{h,m}'
      end
      foundation.subspec 'NSString' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSString/*.{h,m}'
      end
      foundation.subspec 'NSTimer' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/Foundation/NSTimer/*.{h,m}'
      end
    end

    ### 一级目录 QuartzCore ###
    core.subspec 'QuartzCore' do |quartzcore|
        quartzcore.public_header_files = 'ZHHAnneKit/Classes/QuartzCore/ZHHQuartzCore.h'
        quartzcore.source_files = 'ZHHAnneKit/Classes/QuartzCore/ZHHQuartzCore.h'
        quartzcore.subspec 'CALayer' do |subspec|
            subspec.source_files = 'ZHHAnneKit/Classes/QuartzCore/CALayer/*.{h,m}'
        end
        quartzcore.subspec 'CATransaction' do |subspec|
            subspec.source_files = 'ZHHAnneKit/Classes/QuartzCore/CATransaction/*.{h,m}'
        end
    end

    ### 一级目录 UIKit ###
    core.subspec 'UIKit' do |uikit|
      # 公共头文件和源文件
      uikit.public_header_files = 'ZHHAnneKit/Classes/UIKit/ZHHUIKit.h'
      uikit.source_files = 'ZHHAnneKit/Classes/UIKit/ZHHUIKit.h'
      uikit.frameworks = 'UIKit'
      
      # 子模块
      uikit.subspec 'UIApplication' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIApplication/*.{h,m}'
      end
      uikit.subspec 'UIBarButtonItem' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIBarButtonItem/*.{h,m}'
          subspec.dependency 'ZHHAnneKit/Core/BadgeView'
      end
      uikit.subspec 'UIButton' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIButton/*.{h,m}'
          subspec.dependency 'ZHHAnneKit/Core/UIKit/UIImage'
      end
      uikit.subspec 'UICollectionView' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UICollectionView/*.{h,m}'
      end
      uikit.subspec 'UIColor' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIColor/*.{h,m}'
      end
      uikit.subspec 'UIControl' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIControl/*.{h,m}'
          subspec.frameworks = 'AVFoundation'
      end
      uikit.subspec 'UIDevice' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIDevice/*.{h,m}'
          subspec.dependency 'ZHHAnneKit/Core/CommonTools'
      end
      uikit.subspec 'UIImage' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIImage/*.{h,m}'
          subspec.dependency 'ZHHAnneKit/Core/UIKit/UIColor'
      end
      uikit.subspec 'UIImageView' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIImageView/*.{h,m}'
      end
      uikit.subspec 'UILabel' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UILabel/*.{h,m}'
          subspec.dependency 'ZHHAnneKit/Core/UIKit/UIView'
      end
      uikit.subspec 'UINavigationBar' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UINavigationBar/*.{h,m}'
      end
      uikit.subspec 'UINavigationController' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UINavigationController/*.{h,m}'
      end
      uikit.subspec 'UINavigationItem' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UINavigationItem/*.{h,m}'
      end
      uikit.subspec 'UIScrollView' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIScrollView/*.{h,m}'
      end
      uikit.subspec 'UISlider' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UISlider/*.{h,m}'
      end
      uikit.subspec 'UISplitViewController' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UISplitViewController/*.{h,m}'
      end
      uikit.subspec 'UITabBarItem' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UITabBarItem/*.{h,m}'
          subspec.dependency 'ZHHAnneKit/Core/BadgeView'
      end
      uikit.subspec 'UITableView' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UITableView/*.{h,m}'
      end
      uikit.subspec 'UITextField' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UITextField/*.{h,m}'
      end
      uikit.subspec 'UITextView' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UITextView/*.{h,m}'
      end
      uikit.subspec 'UIView' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIView/*.{h,m}'
          subspec.dependency 'ZHHAnneKit/Core/BadgeView'
      end
      uikit.subspec 'UIViewController' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIViewController/*.{h,m}'
          subspec.frameworks = 'Social'
      end
      uikit.subspec 'UIWindow' do |subspec|
          subspec.source_files = 'ZHHAnneKit/Classes/UIKit/UIWindow/*.{h,m}'
      end
    end
  end
end
