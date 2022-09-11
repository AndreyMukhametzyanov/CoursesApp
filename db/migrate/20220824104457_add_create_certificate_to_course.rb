class AddCreateCertificateToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :create_certificate, :boolean, default: false
  end
end
