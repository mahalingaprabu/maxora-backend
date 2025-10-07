class AddIndexToUsersEmail < ActiveRecord::Migration[8.0]
  def change
    unless index_exists?(:users, :email)
      add_index :users, :email, unique: true
    end
  end
end
