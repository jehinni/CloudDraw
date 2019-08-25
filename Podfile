platform :ios, '11.0'

source 'git@gitlab.com:peers-app/specs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'PeersGameDraw' do
  use_frameworks!

  pod 'PeersUI' # our custom UI elements
  pod 'PeersFramework'
  pod 'UICircularProgressRing'

  target 'PeersGameDrawTests' do
    inherit! :search_paths
  end

  target 'PeersGameDrawUITests' do
    inherit! :search_paths
  end

end
