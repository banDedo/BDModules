Pod::Spec.new do |s|
  s.name = 'BDModules'
  s.version = '0.0.3'
  s.license = 'Apache 2.0'
  s.summary = 'Bandedo Swift Modules'
  s.authors = { 'Patrick Hogan' => 'phoganuci@gmail.com' }
  s.ios.deployment_target = '8.0'
  s.homepage = 'https://github.com/banDedo/BDModules'
  s.source = { :git => 'https://github.com/banDedo/BDModules.git', :tag => s.version, :submodules => true }
  s.requires_arc = true

  s.subspec 'Button' do |ss|
    ss.source_files = 'Button/*.swift'
    ss.dependency 'BDModules/Color'
  end

  s.subspec 'BlurView' do |ss|
    ss.source_files = 'BlurView/*.swift'
    ss.dependency 'Snap'
  end

  s.subspec 'Collection' do |ss|
    ss.source_files = 'Collection/*.swift'
  end

  s.subspec 'Color' do |ss|
    ss.source_files = 'Color/*.swift'
  end

  s.subspec 'ContainerViewController' do |ss|
    ss.source_files = 'ContainerViewController/*.swift'
    ss.dependency 'BDModules/ViewAnimations'
    ss.dependency 'Snap'
  end

  s.subspec 'HarnessModules' do |ss|
    ss.dependency 'BDModules/Model'

    ss.subspec 'AccountUser' do |sss|
      sss.source_files = 'HarnessModules/AccountUser/*.swift'
      sss.dependency 'FXKeychain'
      sss.dependency 'BDModules/JSON'
      sss.dependency 'BDModules/Networking/OAuth2'
      sss.dependency 'BDModules/HarnessModules/Model'
    end

    ss.subspec 'API' do |sss|
      sss.source_files = 'HarnessModules/API/**/*.swift'
      sss.resources = 'HarnessModules/API/**/*.json', 'HarnessModules/API/**/*.plist'
      sss.dependency 'BDModules/HarnessModules/AccountUser'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/HarnessModules/UserDefaults'
      sss.dependency 'BDModules/Networking'
      sss.dependency 'FXKeychain'
    end

    ss.subspec 'Application' do |sss|
      sss.source_files = 'HarnessModules/Application/*.swift'
      sss.dependency 'FXKeychain'
      sss.dependency 'BDModules/LifecycleViewController'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/JSON'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/HarnessModules/RootViewController'
    end

    ss.subspec 'Color' do |sss|
      sss.source_files = 'HarnessModules/Color/*.swift'
    end

    ss.subspec 'EntryViewController' do |sss|
      sss.source_files = 'HarnessModules/EntryViewController/*.swift'
      sss.dependency 'BDModules/Button'
      sss.dependency 'BDModules/ContainerViewController'
      sss.dependency 'BDModules/HarnessModules/AccountUser'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/Color'
      sss.dependency 'BDModules/HarnessModules/Font'
      sss.dependency 'BDModules/HarnessModules/Layout'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/HarnessModules/NavigationController'
      sss.dependency 'BDModules/LifecycleViewController'
      sss.dependency 'BDModules/ViewGeometry'
      sss.dependency 'Snap'
    end

    ss.subspec 'FavoritesViewController' do |sss|
      sss.source_files = 'HarnessModules/FavoritesViewController/*.swift'
      sss.dependency 'BDModules/BlurView'
      sss.dependency 'BDModules/HarnessModules/AccountUser'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/Color'
      sss.dependency 'BDModules/HarnessModules/Font'
      sss.dependency 'BDModules/HarnessModules/JSON'
      sss.dependency 'BDModules/HarnessModules/Layout'
      sss.dependency 'BDModules/HarnessModules/NavigationController'
      sss.dependency 'BDModules/ImageViewLazyLoader'
      sss.dependency 'BDModules/LifecycleViewController'
      sss.dependency 'BDModules/Loading'
      sss.dependency 'BDModules/ViewGeometry'
      sss.dependency 'Snap'
    end

    ss.subspec 'Font' do |sss|
      sss.source_files = 'HarnessModules/Font/*.swift'
    end

    ss.subspec 'JSON' do |sss|
      sss.source_files = 'HarnessModules/JSON/*.swift'
      sss.dependency 'BDModules/JSON'
      sss.dependency 'BDModules/Logging'
      sss.dependency 'BDModules/HarnessModules/UserDefaults'
    end

    ss.subspec 'Layout' do |sss|
      sss.source_files = 'HarnessModules/Layout/*.swift'
    end

    ss.subspec 'MainViewController' do |sss|
      sss.source_files = 'HarnessModules/MainViewController/*.swift'
      sss.resources = 'HarnessModules/MainViewController/Images.xcassets'
      sss.dependency 'BDModules/ContainerViewController'
      sss.dependency 'BDModules/HarnessModules/FavoritesViewController'
      sss.dependency 'BDModules/HarnessModules/MapViewController'
      sss.dependency 'BDModules/HarnessModules/MenuViewController'
      sss.dependency 'BDModules/HarnessModules/SettingsViewController'
      sss.dependency 'BDModules/HarnessModules/UserDefaults'
      sss.dependency 'BDModules/Image'
      sss.dependency 'BDModules/ImageBlender'
      sss.dependency 'BDModules/LifecycleViewController'
      sss.dependency 'BDModules/NavigationDrawerViewController'
      sss.dependency 'Snap'
    end

    ss.subspec 'MapViewController' do |sss|
      sss.source_files = 'HarnessModules/MapViewController/*.swift'
      sss.framework    = 'CoreLocation'
      sss.framework    = 'MapKit'
      sss.dependency 'BDModules/HarnessModules/AccountUser'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/Color'
      sss.dependency 'BDModules/HarnessModules/Font'
      sss.dependency 'BDModules/HarnessModules/Layout'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/HarnessModules/NavigationController'
      sss.dependency 'BDModules/HarnessModules/UserDefaults'
      sss.dependency 'BDModules/LifecycleViewController'
      sss.dependency 'BDModules/ViewGeometry'
      sss.dependency 'Snap'
    end

    ss.subspec 'MenuViewController' do |sss|
      sss.source_files = 'HarnessModules/MenuViewController/*.swift'
      sss.resources = 'HarnessModules/MenuViewController/Images.xcassets'
      sss.dependency 'BDModules/Button'
      sss.dependency 'BDModules/HarnessModules/AccountUser'
      sss.dependency 'BDModules/HarnessModules/Color'
      sss.dependency 'BDModules/HarnessModules/Font'
      sss.dependency 'BDModules/HarnessModules/Layout'
      sss.dependency 'BDModules/Image'
      sss.dependency 'BDModules/ImageBlender'
      sss.dependency 'BDModules/ImageViewLazyLoader'
      sss.dependency 'BDModules/LifecycleViewController'
      sss.dependency 'BDModules/ScrollViewParallax'
      sss.dependency 'BDModules/ViewGeometry'
      sss.dependency 'Snap'
    end

    ss.subspec 'NavigationController' do |sss|
      sss.source_files = 'HarnessModules/NavigationController/*.swift'
      sss.resources = 'HarnessModules/NavigationController/Images.xcassets'
      sss.dependency 'BDModules/Color'
      sss.dependency 'BDModules/Image'
      sss.dependency 'BDModules/HarnessModules/Color'
      sss.dependency 'BDModules/HarnessModules/Font'
      sss.dependency 'BDModules/HarnessModules/Layout'
      sss.dependency 'BDModules/ImageBlender'
    end

    ss.subspec 'Model' do |sss|
      sss.source_files = 'HarnessModules/Model/**/*.swift'
      sss.framework    = 'CoreLocation'
      sss.dependency 'BDModules/Logging'
      sss.dependency 'BDModules/Model'
    end

    ss.subspec 'RootViewController' do |sss|
      sss.source_files = 'HarnessModules/RootViewController/*.swift'
      sss.dependency 'BDModules/ContainerViewController'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/EntryViewController'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/HarnessModules/MainViewController'
      sss.dependency 'BDModules/HarnessModules/MenuViewController'
      sss.dependency 'Snap'
    end

    ss.subspec 'SettingsViewController' do |sss|
      sss.source_files = 'HarnessModules/SettingsViewController/*.swift'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/Color'
      sss.dependency 'BDModules/HarnessModules/Font'
      sss.dependency 'BDModules/HarnessModules/JSON'
      sss.dependency 'BDModules/HarnessModules/Layout'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/HarnessModules/NavigationController'
      sss.dependency 'BDModules/HarnessModules/UserDefaults'
      sss.dependency 'BDModules/LifecycleViewController'
      sss.dependency 'BDModules/Logging'
      sss.dependency 'BDModules/ViewGeometry'
      sss.dependency 'Snap'
    end

    ss.subspec 'UserDefaults' do |sss|
      sss.source_files = 'HarnessModules/UserDefaults/*.swift'
      sss.dependency 'BDModules/Logging'
    end
  end

  s.subspec 'Image' do |ss|
    ss.source_files = 'Image/*.swift'
  end

  s.subspec 'ImageBlender' do |ss|
    ss.source_files = 'ImageBlender/*.swift'
  end

  s.subspec 'ImageViewLazyLoader' do |ss|
    ss.source_files = 'ImageViewLazyLoader/*.swift'
    ss.dependency 'BDModules/ViewAnimations'
    ss.dependency 'SDWebImage'
  end
  
  s.subspec 'JSON' do |ss|
    ss.source_files = 'JSON/*.swift'
  end

  s.subspec 'Keyboard' do |ss|
    ss.source_files = 'Keyboard/*.swift'
  end
  
  s.subspec 'LifecycleViewController' do |ss|
    ss.source_files = 'LifecycleViewController/*.swift'
  end

  s.subspec 'Loading' do |ss|
    ss.source_files = 'Loading/*.swift'
    ss.dependency 'BDModules/HarnessModules/Color'
    ss.dependency 'Snap'
  end
  
  s.subspec 'Logging' do |ss|
    ss.source_files = 'Logging/*.{h,m,swift}'
  end
  
  s.subspec 'Model' do |ss|
    ss.source_files = 'Model/*.swift'
    ss.dependency 'BDModules/JSON'
    ss.dependency 'BDModules/Pointers'
  end
  
  s.subspec 'NavigationDrawerViewController' do |ss|
    ss.source_files = 'NavigationDrawerViewController/*.swift'
    ss.dependency 'BDModules/LifecycleViewController'
    ss.dependency 'BDModules/ViewAnimations'
    ss.dependency 'Snap'
  end

  s.subspec 'Networking' do |ss|

    ss.subspec 'Core' do |sss|
      sss.source_files = 'Networking/*.swift'
      sss.dependency 'AFNetworking/NSURLSession'
      sss.dependency 'BDModules/JSON'
      sss.dependency 'BDModules/Logging'
      sss.dependency 'BDModules/Pointers'
    end

    ss.subspec 'APIServiceClient' do |sss|
      sss.source_files = 'Networking/APIServiceClient/*.swift'
      sss.dependency 'BDModules/Model'
      sss.dependency 'BDModules/Networking/Core'
      sss.dependency 'BDModules/Networking/OAuth2'
    end

    ss.subspec 'Repository' do |sss|
      sss.source_files = 'Networking/Repository/*.swift'
      sss.dependency 'BDModules/Collection'
      sss.dependency 'BDModules/Model'
      sss.dependency 'BDModules/Networking/Core'
      sss.dependency 'BDModules/Networking/OAuth2'
    end

    ss.subspec 'OAuth2' do |sss|
      sss.source_files = 'Networking/OAuth2/*.swift'
      sss.dependency 'BDModules/Networking/Core'
    end

  end
  
  s.subspec 'Pointers' do |ss|
    ss.source_files = 'Pointers/*.swift'
  end

  s.subspec 'ScrollViewParallax' do |ss|
    ss.source_files = 'ScrollViewParallax/*.swift'
    ss.dependency 'Snap'
  end

  s.subspec 'ViewAnimations' do |ss|
    ss.source_files = 'ViewAnimations/*.swift'
  end

  s.subspec 'ViewGeometry' do |ss|
    ss.source_files = 'ViewGeometry/*.swift'
  end
end