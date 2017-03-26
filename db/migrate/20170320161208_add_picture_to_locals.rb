class AddPictureToLocals < ActiveRecord::Migration[5.0]
  def change
    add_column :locals, :picture, :string
  end
end
