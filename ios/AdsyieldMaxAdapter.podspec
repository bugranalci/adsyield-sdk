Pod::Spec.new do |s|
  s.name             = 'AdsyieldMaxAdapter'
  s.version          = '1.0.0'
  s.summary          = 'Adsyield adapter for MAX mediation.'
  s.homepage         = 'https://github.com/bugranalci/adsyield-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adsyield' => 'sdk@adsyield.com' }
  s.source           = { :git => 'https://github.com/bugranalci/adsyield-sdk.git', :tag => 'ios-1.0.0' }
  s.vendored_frameworks = 'ios/AdsyieldMaxAdapter.xcframework'
  s.platform         = :ios, '12.0'
  s.requires_arc     = true
end
