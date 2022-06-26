class AddPhysicallyAttendFlag < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :physically_attend, :boolean, default: false
  end
end
