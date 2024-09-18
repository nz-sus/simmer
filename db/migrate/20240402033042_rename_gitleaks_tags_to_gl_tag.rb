class RenameGitleaksTagsToGlTag < ActiveRecord::Migration[7.1]
  def change
    rename_column :gitleaks_results, :tags, :gltags
  end
end
