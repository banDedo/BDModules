Pod::Spec.new do |s|
  s.name = 'BDModules'
  s.version = '0.0.1'
  s.license = 'Apache 2.0'
  s.summary = 'Bandedo Swift Modules'
  s.authors = { 'Patrick Hogan' => 'phoganuci@gmail.com' }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.subspec 'Button' do |ss|
    ss.source_files = 'Button/*.swift'
    ss.dependency 'BDModules/Color'
  end

  s.subspec 'Collection' do |ss|
    ss.source_files = 'Collection/*.swift'
  end

  s.subspec 'Color' do |ss|
    ss.source_files = 'Color/*.swift'
  end

  s.subspec 'ContainerViewController' do |ss|
    ss.source_files = 'ContainerViewController/*.swift'
    ss.dependency 'Snap'
  end

  s.subspec 'HarnessModules' do |ss|
    ss.dependency 'BDModules/Model'

    ss.subspec 'AccountUser' do |sss|
      sss.source_files = 'HarnessModules/AccountUser/*.swift'
      sss.dependency 'FXKeychain'
      sss.dependency 'BDModules/JSON'
    end

    ss.subspec 'API' do |sss|
      sss.source_files = 'HarnessModules/API/**/*.swift'
      sss.resources = 'HarnessModules/API/**/*.json', 'HarnessModules/API/**/*.plist'
      sss.dependency 'BDModules/Model'
      sss.dependency 'BDModules/Networking'
    end

    ss.subspec 'Application' do |sss|
      sss.source_files = 'HarnessModules/Application/*.swift'
      sss.dependency 'FXKeychain'
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
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/Button'
      sss.dependency 'Snap'
    end

    ss.subspec 'JSON' do |sss|
      sss.source_files = 'HarnessModules/JSON/*.swift'
      sss.dependency 'BDModules/JSON'
    end

    ss.subspec 'MainViewController' do |sss|
      sss.source_files = 'HarnessModules/MainViewController/*.swift'
      sss.framework    = 'CoreLocation'
      sss.framework    = 'MapKit'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'BDModules/Button'
      sss.dependency 'Snap'
    end

    ss.subspec 'NavigationController' do |sss|
      sss.source_files = 'HarnessModules/NavigationController/*.swift'
      sss.dependency 'BDModules/Color'
    end

    ss.subspec 'Model' do |sss|
      sss.source_files = 'HarnessModules/Model/**/*.swift'
      sss.framework    = 'CoreLocation'
      sss.dependency 'BDModules/Logging'
      sss.dependency 'BDModules/Model'
    end

    ss.subspec 'RootViewController' do |sss|
      sss.source_files = 'HarnessModules/RootViewController/*.swift'
      sss.dependency 'BDModules/HarnessModules/API'
      sss.dependency 'BDModules/HarnessModules/Model'
      sss.dependency 'Snap'
    end
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
  
  s.subspec 'Logging' do |ss|
    ss.source_files = 'Logging/*.{h,m,swift}'
  end
  
  s.subspec 'Model' do |ss|
    ss.source_files = 'Model/*.swift'
    ss.dependency 'BDModules/JSON'
  end
  
  s.subspec 'Networking' do |ss|
    ss.source_files = 'Networking/*.swift', 'Networking/URLProtocol/*.swift'
    ss.dependency 'AFNetworking/NSURLSession'
    ss.dependency 'BDModules/JSON'
    ss.dependency 'BDModules/Logging'
    ss.dependency 'BDModules/Pointers'

    ss.subspec 'APIServiceClient' do |sss|
      sss.source_files = 'Networking/APIServiceClient/*.swift'
      sss.dependency 'BDModules/Model'

      sss.subspec 'Repository' do |ssss|
        ssss.source_files = 'Networking/Repository/*.swift'
        ssss.dependency 'BDModules/Collection'
      end
    end

    ss.subspec 'OAuth2' do |sss|
      sss.source_files = 'Networking/OAuth2/*.swift'
    end

  end
  
  s.subspec 'Pointers' do |ss|
    ss.source_files = 'Pointers/*.swift'
  end
end