class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes, id: :uuid do |t|
      t.text :content
      t.references :noteable, polymorphic: true, null: false, type: :uuid

      t.timestamps
      t.index [:noteable_type, :noteable_id]
    end
  end
end
