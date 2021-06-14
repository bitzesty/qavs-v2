class RemoveQaeTables < ActiveRecord::Migration[6.0]

  def down
    raise IrreversibleMigration
  end

  def up
    drop_table :feedback_hard_copy_pdfs
    drop_table :case_summary_hard_copy_pdfs
    drop_table :judges
    drop_table :list_of_procedures
    drop_table :supporters
    drop_table :press_summaries
    drop_table :audit_certificates

    remove_column :form_answers, :award_type
    remove_column :form_answers, :award_type_full_name
    remove_column :assessors, :trade_role
    remove_column :assessors, :innovation_role
    remove_column :assessors, :development_role
    remove_column :assessors, :promotion_role
    remove_column :assessors, :mobility_role

    add_column :assessors, :qavs_role, :string

    remove_column :users, :notification_when_innovation_award_open
    remove_column :users, :notification_when_trade_award_open
    remove_column :users, :notification_when_development_award_open
    remove_column :users, :notification_when_mobility_award_open
  end

end
