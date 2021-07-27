# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_07_052346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "affiliation_name", ["First Order", "Galactic Republic", "Gungan Grand Army", "Hutt Clan", "Jedi Order", "Rebel Alliance", "Sith", "The Resistance"]
  create_enum "location_name", ["Alderaan", "Chandrila", "Cloud City", "Corellia", "Death Star", "Haruun Kal", "Jakku", "Kamino", "Kashyyk", "Naboo", "Stewjon", "Tatooine", "Yoda's Hut"]
  create_enum "person_gender", ["Male", "Female", "Other"]
  create_enum "person_species", ["Astromech Droid", "Gungan", "Human", "Hutt", "Protocol Droid", "Unknown", "Wookie"]
  create_enum "person_vehicle", ["Gungan Bongo Submarine", "Jabba's Sail Barge", "Jedi Starfighter", "Millennium Falcon", "Naboo N-1 Starfighter", "Rey's Speeder", "Slave 1", "Tiefighter", "X-wing Starfighter"]
  create_enum "person_weapon", ["Blaster", "Blaster Pistol", "Bowcaster", "Energy Ball", "Lightsaber"]

  create_table "affiliations", force: :cascade do |t|
    t.enum "name", null: false, as: "affiliation_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_affiliations_on_name", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.enum "name", null: false, as: "location_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "loyalties", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "affiliation_id"
    t.index ["affiliation_id"], name: "index_loyalties_on_affiliation_id"
    t.index ["person_id", "affiliation_id"], name: "index_loyalties_on_person_id_and_affiliation_id", unique: true
    t.index ["person_id"], name: "index_loyalties_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "prefix"
    t.string "first_name", null: false
    t.string "last_name"
    t.string "suffix"
    t.enum "species", null: false, as: "person_species"
    t.enum "gender", null: false, as: "person_gender"
    t.enum "weapon", as: "person_weapon"
    t.enum "vehicle", as: "person_vehicle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_name", "species", "gender"], name: "index_people_on_first_name_and_species_and_gender", unique: true
  end

  create_table "residences", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_residences_on_location_id"
    t.index ["person_id", "location_id"], name: "index_residences_on_person_id_and_location_id", unique: true
    t.index ["person_id"], name: "index_residences_on_person_id"
  end

end
