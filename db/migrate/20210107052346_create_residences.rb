class CreateResidences < ActiveRecord::Migration[6.1]
  def change
    create_table :residences do |t|
      t.belongs_to :person
      t.belongs_to :location
    end
    add_index :residences, [:person_id, :location_id], unique: true
  end
end
