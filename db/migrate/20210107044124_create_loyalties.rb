class CreateLoyalties < ActiveRecord::Migration[6.1]
  def change
    create_table :loyalties do |t|
      t.belongs_to :person
      t.belongs_to :affiliation
    end
  end
end
