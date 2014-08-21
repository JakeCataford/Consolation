module Loggable
  extend ActiveSupport::Concern

  class ConsolationLogRollupError < StandardError; end


  included do
    has_many :log_chunks, as: :loggable
    scope :log_chunks_tail, -> { @log_chunks.all(order: :id).last }

    delegate :url_helpers, to: "Rails.application.routes"
    alias :h :url_helpers

    def rollup_logs(content_field = :logs)
      log_chunks.each do |chunk|
        send(content_field) << chunk
      end

      if(save)
        log_chunks.each { |chunk| chunk.destroy! }
      else
        raise ConsolationLogRollupError, "Failed to rollup logs into field #{content_field}."
      end
    end

    def append_log_chunk(log_contents)
      log_chunks.create!(content: log_contents)
    end

    def last_log_chunk_id
      log_chunks.pluck(:id).max
    end

    def tail_path
      path + "/tail?last_id=#{last_log_chunk_id}"
    end

    def path
      h.send :"#{self.route}_path", parameterize
    end

    def route
      self.class.name.parameterize
    end

    def parameterize
      self.id
    end

  end
end
