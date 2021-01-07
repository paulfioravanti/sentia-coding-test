class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_enum(
      :location_name,
      [
        "Alderaan",
        "Chandrila",
        "Cloud City",
        "Corellia",
        "Death Star",
        "Haruun Kal",
        "Jakku",
        "Kamino",
        "Kashyyk",
        "Naboo",
        "Stewjon",
        "Tatooine",
        "Yoda''s Hutt"
      ]
    )

    create_table :locations do |t|
      t.enum :name, as: :location_name, null: false, unique: true
      t.timestamps
    end

    add_index :locations, :name, unique: true
  end
end
