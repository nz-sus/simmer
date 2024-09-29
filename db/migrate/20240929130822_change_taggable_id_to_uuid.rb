class ChangeTaggableIdToUuid < ActiveRecord::Migration[7.1]
  def change
    # remove and replace the taggable_id column
    remove_column :taggings, :taggable_id
    add_column :taggings, :taggable_id, :uuid
  end
end
