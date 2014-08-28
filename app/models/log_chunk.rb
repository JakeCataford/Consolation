class LogChunk < ActiveRecord::Base
  MYSQL_MAX_TEXT_SIZE = 64000

  before_create :split_up_log_chunks
  belongs_to :loggable, polymorphic: true, touch: true

  scope :tail, -> (start) { where('id > ?', start || 0) }

  private

  def split_up_log_chunks
    until(content.bytesize <= MYSQL_MAX_TEXT_SIZE)

      chunk = content.each_char.each_with_object('') do |char, result|
        if(result.bytesize + char.bytesize > MYSQL_MAX_TEXT_SIZE)
          break result
        else
          result << char
        end
      end

      content.slice!(chunk)

      new = self.dup()
      new.content = chunk
      new.save!
    end

    true
  end
end
