class LogChunk < ActiveRecord::Base
  belongs_to :loggable, polymorphic: true, touch: true

  scope :tail, -> (start) { where('id > ?', start || 0) }
end
