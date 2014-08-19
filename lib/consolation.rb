module Consolation
  class Engine < ::Rails::Engine
    require 'ansi_stream'
    isolate_namespace Consolation

    initializer 'consolation.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Consolation::ConsolationHelper
      end
    end

  end
end
