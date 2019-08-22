platform :ios, '11.0'

source 'git@gitlab.mi.hdm-stuttgart.de:peers/specs.git'

target 'PeersGameDraw' do
  use_frameworks!

  pod 'PeersUI' # our custom UI elements
  pod 'PeersFramework'

  target 'PeersGameDrawTests' do
    inherit! :search_paths
  end

  target 'PeersGameDrawUITests' do
    inherit! :search_paths
  end

end
