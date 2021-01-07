class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_enum(
      :person_species,
      %w(ASTROMECH_DROID GUNGAN HUMAN PROTOCOL_DROID UNKNOWN WOOKIE)
    )
    create_enum(:person_gender, %w(MALE FEMALE OTHER))
    create_enum(
      :person_weapon,
      %w(BLASTER BLASTER_PISTOL BOWCASTER ENERGY_BALL LIGHTSABER)
    )
    create_enum(
      :person_vehicle,
      %w(
        GUNGAN_BONGO_SUBMARINE
        JABBAS_SAIL_BARGE
        JEDI_STARFIGHTER
        MILLENIUM_FALCON
        NABOO_N1_STARFIGHTER
        REYS_SPEEDER
        SLAVE_ONE
        TIEFIGHTER
        XWING_STARFIGHTER
      )
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
  end
end
