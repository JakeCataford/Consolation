module LoggableController
  extend ActiveSupport::Concern

  included do

    def tail
      chunks = @loggable.log_chunks.tail(params[:last_id])
      respond_with({
          url: @loggable.log_tail_url,
          log_chunks: chunks,
          :"#{@loggable.class.name.parameterize}" => @loggable
        })
    end

  end

end
