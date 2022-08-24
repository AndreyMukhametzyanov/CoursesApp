class CreateCertificates < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.belongs_to :order, null: false, foreing_key: true
      t.text :uniq_code
      t.timestamps
    end
  end
end
