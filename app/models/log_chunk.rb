class LogChunk < ActiveRecord::Base
  belongs_to :loggable, polymorphic: true
end
