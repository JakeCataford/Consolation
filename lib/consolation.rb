module Consolation
  class Engine < ::Rails::Engine
    isolate_namespace Consolation

    initializer 'consolation.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper ConsolationHelper
      end
    end

  end
end
