Pod::Spec.new do |s|
  s.name             = 'ZHHAnneKit'
  s.version          = '0.1.2'
  s.summary          = '一套实用的分类与工具库，提升开发效率。'
  s.description      = <<-DESC
  ZHHAnneKit 提供了一系列常用的分类和工具类，涵盖 Foundation、UIKit 和 QuartzCore 等模块，旨在简化日常开发工作，提高代码复用性和开发效率。
  DESC
  s.homepage         = 'https://github.com/yue5yueliang/ZHHAnneKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHAnneKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'

  # 公共头文件
  s.public_header_files = 'ZHHAnneKit/Classes/ZHHAnneKit.h'

  # 源文件路径
  s.source_files = 'ZHHAnneKit/Classes/ZHHAnneKit.h'

  ### 一级目录 CommonTools ###
  s.subspec 'CommonTools' do |commontools|
    commontools.public_header_files = 'ZHHAnneKit/Classes/CommonTools/ZHHCommonKit.h'
    commontools.source_files = 'ZHHAnneKit/Classes/CommonTools/**/*.{h,m}'
  end

  ### 一级目录 Foundation ###
  s.subspec 'Foundation' do |foundation|
    # 指定公共头文件
    foundation.public_header_files = 'ZHHAnneKit/Classes/Foundation/ZHHFoundation.h'
    # 为公共头文件所在文件夹添加源文件加载
    foundation.source_files = 'ZHHAnneKit/Classes/Foundation/ZHHFoundation.h'
    # 子模块
    %w[NSArray NSAttributedString NSBundle NSData NSDate NSDecimalNumber
    NSDictionary NSException NSFileManager NSIndexPath NSNotification
    NSNotificationCenter NSNumber NSObject NSString NSTimer].each do |subspec_name|
      foundation.subspec subspec_name do |subspec|
        subspec.source_files = "ZHHAnneKit/Classes/Foundation/#{subspec_name}/*.{h,m}"
      end
    end
  end

  ### 一级目录 QuartzCore ###
  s.subspec 'QuartzCore' do |quartzcore|
    # 指定公共头文件
    quartzcore.public_header_files = 'ZHHAnneKit/Classes/QuartzCore/ZHHQuartzCore.h'
    # 为公共头文件所在文件夹添加源文件加载
    quartzcore.source_files = 'ZHHAnneKit/Classes/QuartzCore/ZHHQuartzCore.h'
    # 子模块
    %w[CALayer CATransaction].each do |subspec_name|
      quartzcore.subspec subspec_name do |subspec|
        subspec.source_files = "ZHHAnneKit/Classes/QuartzCore/#{subspec_name}/*.{h,m}"
      end
    end
  end

  ### 一级目录 UIKit ###
  s.subspec 'UIKit' do |uikit|
      # 指定公共头文件
    uikit.public_header_files = 'ZHHAnneKit/Classes/UIKit/ZHHUIKit.h'
    # 为公共头文件所在文件夹添加源文件加载
    uikit.source_files = 'ZHHAnneKit/Classes/UIKit/ZHHUIKit.h'
    # 子模块
    %w[UIApplication UIBarButtonItem UIButton UICollectionView
    UIColor UIControl UIDevice UIImage UIImageView UILabel UINavigationBar
    UINavigationController UINavigationItem UISlider UISplitViewController
    UITableView UITextField UITextView UIView UIViewController UIWindow].each do |subspec_name|
      uikit.subspec subspec_name do |subspec|
        subspec.source_files = "ZHHAnneKit/Classes/UIKit/#{subspec_name}/*.{h,m}"

        # 根据依赖添加子模块依赖关系
        case subspec_name
        when 'UIBarButtonItem'
          subspec.dependency 'ZHHAnneKit/UIKit/UIView'
          subspec.dependency 'ZHHAnneKit/UIKit/UIColor'
        when 'UIButton'
          subspec.dependency 'ZHHAnneKit/UIKit/UIImage'
        when 'UIImage'
          subspec.dependency 'ZHHAnneKit/UIKit/UIColor'
        when 'UILabel'
          subspec.dependency 'ZHHAnneKit/UIKit/UIView'
        end
      end
    end
  end
end
