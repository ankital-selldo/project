class RenamePasswordToPasswordDigestInStudents < ActiveRecord::Migration[8.0]
  def change
    rename_column :students, :password, :password_digest
  end
end
