class AddConstraintsToMostRecentForFormAnswerTransitions < ActiveRecord::Migration
  disable_ddl_transaction!

  def up
    system('bundle exec rake statesman:backfill_most_recent[FormAnswer]')
    add_index :form_answer_transitions, [:form_answer_id, :most_recent], unique: true, where: "most_recent", name: "index_form_answer_transitions_parent_most_recent", algorithm: :concurrently
    change_column_null :form_answer_transitions, :most_recent, false
  end

  def down
    remove_index :form_answer_transitions, name: "index_form_answer_transitions_parent_most_recent"
    change_column_null :form_answer_transitions, :most_recent, true
  end
end
