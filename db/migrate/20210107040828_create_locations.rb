class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_enum(
      :location_name,
      %w(
        ALDERAAN
        CHANDRILA
        CLOUD_CITY
        CORELLIA
        DEATH_STAR
        HARUUN_KAL
        JAKKU
        KAMINO
        KASHYYK
        NABOO
        STEWJON
        TATOOINE
        YODAS_HUT
      )
    )

    create_table :locations do |t|
      t.enum :name, as: :location_name, null: false, unique: true
      t.timestamps
    end

    add_index :locations, :name, unique: true
  end
end
