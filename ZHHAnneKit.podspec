#
# Be sure to run `pod lib lint ZHHAnneKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHHAnneKit'
  s.version          = '0.0.4'
  s.summary          = '项目常用的拓展方法,方便自己开发.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
项目中常用到的一些分类及工具类,方便自己开发.
                       DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHAnneKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHAnneKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.public_header_files = 'ZHHAnneKit/Classes/ZHHAnneKit.h'
  s.source_files = 'ZHHAnneKit/Classes/ZHHAnneKit.h'
  
  s.subspec 'Foundation' do |foundation|
#        foundation.source_files = 'ZHHAnneKit/Classes/Foundation/**/*.{h,m}'
#        foundation.source_files = 'ZHHAnneKit/Classes/Foundation/**/*.{h,m}'
        foundation.public_header_files = 'ZHHAnneKit/Classes/Foundation/ZHHFoundation.h'
        foundation.source_files = 'ZHHAnneKit/Classes/Foundation/ZHHFoundation.h'
        #三级
        foundation.subspec 'NSArray' do |array|
            array.source_files = 'ZHHAnneKit/Classes/Foundation/NSArray/*.{h,m}'
        end
        foundation.subspec 'NSAttributedString' do |attrstring|
            attrstring.source_files = 'ZHHAnneKit/Classes/Foundation/NSAttributedString/*.{h,m}'
        end
        foundation.subspec 'NSBundle' do |bundle|
            bundle.source_files = 'ZHHAnneKit/Classes/Foundation/NSBundle/*.{h,m}'
        end
        foundation.subspec 'NSData' do |data|
            data.source_files = 'ZHHAnneKit/Classes/Foundation/NSData/*.{h,m}'
        end
        foundation.subspec 'NSDate' do |date|
            date.source_files = 'ZHHAnneKit/Classes/Foundation/NSDate/*.{h,m}'
        end
        foundation.subspec 'NSDecimalNumber' do |decimalnumber|
            decimalnumber.source_files = 'ZHHAnneKit/Classes/Foundation/NSDecimalNumber/*.{h,m}'
        end
        foundation.subspec 'NSDictionary' do |dictionary|
            dictionary.source_files = 'ZHHAnneKit/Classes/Foundation/NSDictionary/*.{h,m}'
        end
        foundation.subspec 'NSException' do |exception|
            exception.source_files = 'ZHHAnneKit/Classes/Foundation/NSException/*.{h,m}'
        end
        foundation.subspec 'NSFileManager' do |filemanager|
            filemanager.source_files = 'ZHHAnneKit/Classes/Foundation/NSFileManager/*.{h,m}'
        end
        foundation.subspec 'NSIndexPath' do |indexpath|
            indexpath.source_files = 'ZHHAnneKit/Classes/Foundation/NSIndexPath/*.{h,m}'
        end
        foundation.subspec 'NSNotification' do |notification|
            notification.source_files = 'ZHHAnneKit/Classes/Foundation/NSNotification/*.{h,m}'
        end
        foundation.subspec 'NSNotificationCenter' do |notificationcenter|
            notificationcenter.source_files = 'ZHHAnneKit/Classes/Foundation/NSNotificationCenter/*.{h,m}'
        end
        foundation.subspec 'NSNumber' do |number|
            number.source_files = 'ZHHAnneKit/Classes/Foundation/NSNumber/*.{h,m}'
        end
        foundation.subspec 'NSObject' do |object|
            object.source_files = 'ZHHAnneKit/Classes/Foundation/NSObject/*.{h,m}'
        end
        foundation.subspec 'NSString' do |string|
            string.source_files = 'ZHHAnneKit/Classes/Foundation/NSString/*.{h,m}'
        end
        foundation.subspec 'NSTimer' do |timer|
            timer.source_files = 'ZHHAnneKit/Classes/Foundation/NSTimer/*.{h,m}'
        end
        foundation.subspec 'NSURL' do |url|
            url.source_files = 'ZHHAnneKit/Classes/Foundation/NSURL/*.{h,m}'
        end
    end
  
    s.subspec 'UIKit' do |uikit|
#        uikit.source_files = 'ZHHAnneKit/Classes/UIKit/**/*.{h,m}'
        uikit.public_header_files = 'ZHHAnneKit/Classes/UIKit/ZHHUIKit.h'
        uikit.source_files = 'ZHHAnneKit/Classes/UIKit/ZHHUIKit.h'
        uikit.frameworks = 'UIKit'
        
        uikit.subspec 'UIApplication' do |application|
            application.source_files = 'ZHHAnneKit/Classes/UIKit/UIApplication/*.{h,m}'
        end
        uikit.subspec 'UIBarButtonItem' do |barbuttonitem|
            barbuttonitem.source_files = 'ZHHAnneKit/Classes/UIKit/UIBarButtonItem/*.{h,m}'
            barbuttonitem.dependency 'ZHHAnneKit/UIKit/UIColor'
            barbuttonitem.dependency 'ZHHAnneKit/UIKit/UIImage'
            barbuttonitem.dependency 'ZHHAnneKit/UIKit/UIView'
        end
        uikit.subspec 'UIButton' do |button|
            button.source_files = 'ZHHAnneKit/Classes/UIKit/UIButton/*.{h,m}'
            button.dependency 'ZHHAnneKit/UIKit/UIImage'
        end
        uikit.subspec 'UIColor' do |color|
            color.source_files = 'ZHHAnneKit/Classes/UIKit/UIColor/*.{h,m}'
        end
        uikit.subspec 'UIControl' do |control|
            control.source_files = 'ZHHAnneKit/Classes/UIKit/UIControl/*.{h,m}'
        end
        uikit.subspec 'UIDevice' do |device|
            device.source_files = 'ZHHAnneKit/Classes/UIKit/UIDevice/*.{h,m}'
            device.dependency 'ZHHAnneKit/Foundation/NSString'
        end
        uikit.subspec 'UIFont' do |font|
            font.source_files = 'ZHHAnneKit/Classes/UIKit/UIFont/*.{h,m}'
        end
        uikit.subspec 'UIImage' do |image|
            image.source_files = 'ZHHAnneKit/Classes/UIKit/UIImage/*.{h,m}'
            image.dependency 'ZHHAnneKit/UIKit/UIColor'
        end
        uikit.subspec 'UILabel' do |label|
            label.source_files = 'ZHHAnneKit/Classes/UIKit/UILabel/*.{h,m}'
        end
        uikit.subspec 'UINavigationBar' do |navigationbar|
            navigationbar.source_files = 'ZHHAnneKit/Classes/UIKit/UINavigationBar/*.{h,m}'
        end
        uikit.subspec 'UINavigationController' do |navigationcontroller|
            navigationcontroller.source_files = 'ZHHAnneKit/Classes/UIKit/UINavigationController/*.{h,m}'
        end
        uikit.subspec 'UINavigationItem' do |navigationitem|
            navigationitem.source_files = 'ZHHAnneKit/Classes/UIKit/UINavigationItem/*.{h,m}'
        end
        uikit.subspec 'UIScreen' do |screen|
            screen.source_files = 'ZHHAnneKit/Classes/UIKit/UIScreen/*.{h,m}'
        end
        uikit.subspec 'UISlider' do |slider|
            slider.source_files = 'ZHHAnneKit/Classes/UIKit/UISlider/*.{h,m}'
        end
        uikit.subspec 'UISplitViewController' do |splitviewcontroller|
            splitviewcontroller.source_files = 'ZHHAnneKit/Classes/UIKit/UISplitViewController/*.{h,m}'
        end
        uikit.subspec 'UITabBar' do |tabbar|
            tabbar.source_files = 'ZHHAnneKit/Classes/UIKit/UITabBar/*.{h,m}'
        end
        uikit.subspec 'UITableView' do |tableview|
            tableview.source_files = 'ZHHAnneKit/Classes/UIKit/UITableView/*.{h,m}'
        end
        uikit.subspec 'UITextField' do |textfield|
            textfield.source_files = 'ZHHAnneKit/Classes/UIKit/UITextField/*.{h,m}'
        end
        uikit.subspec 'UITextView' do |textview|
            textview.source_files = 'ZHHAnneKit/Classes/UIKit/UITextView/*.{h,m}'
        end
        uikit.subspec 'UIView' do |view|
            view.source_files = 'ZHHAnneKit/Classes/UIKit/UIView/*.{h,m}'
        end
        uikit.subspec 'UIViewController' do |viewcontroller|
            viewcontroller.source_files = 'ZHHAnneKit/Classes/UIKit/UIViewController/*.{h,m}'
        end
        uikit.subspec 'UIWindow' do |window|
            window.source_files = 'ZHHAnneKit/Classes/UIKit/UIWindow/*.{h,m}'
        end
    end
    
    #CommonTools
    s.subspec 'QuartzCore' do |quartzcore|
        quartzcore.public_header_files = 'ZHHAnneKit/Classes/QuartzCore/ZHHQuartzCore.h'
        quartzcore.source_files = 'ZHHAnneKit/Classes/QuartzCore/ZHHQuartzCore.h'
        quartzcore.subspec 'CALayer' do |calayer|
          calayer.source_files = 'ZHHAnneKit/Classes/QuartzCore/CALayer/*.{h,m}'
        end
        quartzcore.subspec 'CATransaction' do |catransaction|
          catransaction.source_files = 'ZHHAnneKit/Classes/QuartzCore/CATransaction/*.{h,m}'
        end
    end
  
    #CommonTools
    s.subspec 'CommonTools' do |commontools|
        commontools.source_files = 'ZHHAnneKit/Classes/CommonTools/**/*.{h,m}'
#        commontools.public_header_files = 'ZHHAnneKit/Classes/CommonTools/ZHHCommonKit.h'
#        commontools.source_files = 'ZHHAnneKit/Classes/CommonTools/ZHHCommonKit.h'
    end
  
  # s.resource_bundles = {
  #   'ZHHAnneKit' => ['ZHHAnneKit/Classes/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
