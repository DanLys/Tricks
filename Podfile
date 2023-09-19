require_relative 'Scripts/Modules/my_modules'
require_relative 'Scripts/Modules/make_spec'
require_relative 'Scripts/common'

platform :ios, DEPLOYMENT_TARGET

abstract_target 'all' do
  target :'TricksMap' do
    my_module 'Test'
  end

  target 'TricksMapTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TricksMapUITests' do
    # Pods for testing
  end

end
