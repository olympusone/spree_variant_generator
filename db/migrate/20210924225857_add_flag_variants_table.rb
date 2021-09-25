class AddFlagVariantsTable < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_variants, :generated, :boolean, default: false
  end
end
