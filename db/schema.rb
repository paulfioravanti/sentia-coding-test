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

ActiveRecord::Schema.define(version: 2021_01_07_040828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "location_name", ["ALDERAAN", "CHANDRILA", "CLOUD_CITY", "CORELLIA", "DEATH_STAR", "HARUUN_KAL", "JAKKU", "KAMINO", "KASHYYK", "NABOO", "STEWJON", "TATOOINE", "YODAS_HUT"]
  create_enum "person_gender", ["MALE", "FEMALE", "OTHER"]
  create_enum "person_species", ["ASTROMECH_DROID", "GUNGAN", "HUMAN", "PROTOCOL_DROID", "UNKNOWN", "WOOKIE"]
  create_enum "person_vehicle", ["GUNGAN_BONGO_SUBMARINE", "JABBAS_SAIL_BARGE", "JEDI_STARFIGHTER", "MILLENIUM_FALCON", "NABOO_N1_STARFIGHTER", "REYS_SPEEDER", "SLAVE_ONE", "TIEFIGHTER", "XWING_STARFIGHTER"]
  create_enum "person_weapon", ["BLASTER", "BLASTER_PISTOL", "BOWCASTER", "ENERGY_BALL", "LIGHTSABER"]

  create_table "locations", force: :cascade do |t|
    t.enum "name", null: false, as: "location_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
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
  end

end
