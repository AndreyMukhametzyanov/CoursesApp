class AddProgressToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :progress, :json
  end
end
