module Loggable
  extend ActiveSupport::Concern

  class ConsolationLogRollupError < StandardError; end


  included do
    has_many :log_chunks, as: :loggable
    scope :log_chunks_tail, -> { @log_chunks.all(order: :id).last }

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

    def next_log_id
      @log_chunks_tail
    end

  end
end
