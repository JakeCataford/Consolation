class CreateLoggies < ActiveRecord::Migration
  def change
    create_table :loggies do |t|

      t.timestamps
    end
  end
end
