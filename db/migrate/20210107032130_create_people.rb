class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_enum(
      :person_species,
      [
        "Astromech Droid",
        "Gungan",
        "Human",
        "Hutt",
        "Protocol Droid",
        "Unknown",
        "Wookie"
      ]
    )
    create_enum(:person_gender, %w(Male Female Other))
    create_enum(
      :person_weapon,
      ["Blaster", "Blaster Pistol", "Bowcaster", "Energy Ball", "Lightsaber"]
    )
    # NOTE: Double single quotes are for escaping single quotes in Postgres.
    # REF: https://stackoverflow.com/questions/12316953/insert-text-with-single-quotes-in-postgresql
    create_enum(
      :person_vehicle,
      [
        "Gungan Bongo Submarine",
        "Jabba''s Sail Barge",
        "Jedi Starfighter",
        "Millennium Falcon",
        "Naboo N-1 Starfighter",
        "Rey''s Speeder",
        "Slave 1",
        "TIE Fighter",
        "X-wing Starfighter"
      ]
    )

    create_table :people do |t|
      t.string :prefix
      t.string :first_name, null: false
      t.string :last_name
      t.string :suffix
      t.enum :species, as: :person_species, null: false
      t.enum :gender, as: :person_gender, null: false
      t.enum :weapon, as: :person_weapon
      t.enum :vehicle, as: :person_vehicle

      t.timestamps
    end

    add_index :people, [:first_name, :species, :gender], unique: true
  end
end
