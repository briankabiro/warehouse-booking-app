class AddOverlappingConstraintToSlots < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TRIGGER slots_exclude_overlapping
      BEFORE INSERT ON slots
      WHEN EXISTS (
        SELECT 1 FROM slots
        WHERE (NEW.start_time < end_time) AND (NEW.end_time > start_time)
      )
      BEGIN
        SELECT RAISE(ABORT, 'Time ranges cannot overlap');
      END;
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS slots_exclude_overlapping;
    SQL
  end
end
