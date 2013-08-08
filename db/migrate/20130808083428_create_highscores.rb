class CreateHighscores < ActiveRecord::Migration
  def change
    create_table :highscores do |t|
      t.string :name
      t.string :score

      t.timestamps
    end
  end
end
