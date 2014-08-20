class LoggableRoute

  def initialize(defaults = {})
    @defaults = defaults
  end

  def call(mapper, options = {})
    options = @defaults.merge(options)
    mapper.get :tail
  end

end
