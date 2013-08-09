class ChangeScoreToInteger < ActiveRecord::Migration
  def up
    change_column :highscores, :score, :integer
  end

  def down
  end
end
