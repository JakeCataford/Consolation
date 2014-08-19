module Consolation
  class Engine < ::Rails::Engine
    require 'ansi_stream'
    isolate_namespace Consolation
  end
end
