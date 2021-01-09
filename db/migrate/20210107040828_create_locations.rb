class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    # NOTE: Double single quotes are for escaping single quotes in Postgres.
    # REF: https://stackoverflow.com/questions/12316953/insert-text-with-single-quotes-in-postgresql
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
        "Yoda''s Hut"
      ]
    )

    create_table :locations do |t|
      t.enum :name, as: :location_name, null: false
      t.timestamps
    end

    add_index :locations, :name, unique: true
  end
end
