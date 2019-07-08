class CreateDogs < ActiveRecord::Migration[5.2]
  validates_presence_of :name, :email, :password
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
    end
  end
end