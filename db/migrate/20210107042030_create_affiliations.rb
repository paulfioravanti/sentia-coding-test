class CreateAffiliations < ActiveRecord::Migration[6.1]
  def change
    create_enum(
      :affiliation_name,
      %w(
        FIRST_ORDER
        GALACTIC_REPUBLIC
        GUNGAN_GRAND_ARMY
        HUTT_CLAN
        JEDI_ORDER
        REBEL_ALLIANCE
        SITH
        THE_RESISTANCE
      )
    )

    create_table :affiliations do |t|
      t.enum :name, as: :affiliation_name, null: false, unique: true
      t.timestamps
    end

    add_index :affiliations, :name, unique: true
  end
end
