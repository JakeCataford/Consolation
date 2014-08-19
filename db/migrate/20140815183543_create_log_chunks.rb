class CreateLogChunks < ActiveRecord::Migration
  def change
    create_table :log_chunks do |t|
      t.text   :content
      t.string :loggable_id
      t.string :loggable_type
      t.timestamps
    end
  end
end
