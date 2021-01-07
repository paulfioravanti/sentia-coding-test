class CreateAffiliations < ActiveRecord::Migration[6.1]
  def change
    create_enum(
      :affiliation_name,
      [
        "First Order",
        "Galactic Republic",
        "Gungan Grand Army",
        "Hutt Clan",
        "Jedi Order",
        "Rebel Alliance",
        "Sith",
        "The Resistance"
      ]
    )

    create_table :affiliations do |t|
      t.enum :name, as: :affiliation_name, null: false, unique: true
      t.timestamps
    end

    add_index :affiliations, :name, unique: true
  end
end
