class AddConstraintsToMostRecentForFormAnswerTransitions < ActiveRecord::Migration[4.2]
  disable_ddl_transaction!

  def up
    Rake::Task['statesman:backfill_most_recent_fixed'].invoke("FormAnswer")
    FormAnswerTransition.where(most_recent: nil).update_all(most_recent: false)
    add_index :form_answer_transitions, [:form_answer_id, :most_recent], unique: true, where: "most_recent", name: "index_form_answer_transitions_parent_most_recent", algorithm: :concurrently rescue ""
    change_column_null :form_answer_transitions, :most_recent, false
  end

  def down
    remove_index :form_answer_transitions, name: "index_form_answer_transitions_parent_most_recent" rescue ""
    change_column_null :form_answer_transitions, :most_recent, true
  end
end
