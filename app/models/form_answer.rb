require_relative '../../forms/award_years/v2022/qae_forms'
require_relative '../../forms/award_years/v2023/qae_forms'
require_relative '../../forms/award_years/v2024/qae_forms'
require_relative '../../forms/award_years/v2025/qae_forms'
require_relative '../../forms/award_years/v2026/qae_forms'
require_relative '../../forms/award_years/v2027/qae_forms'

class FormAnswer < ApplicationRecord
include Statesman::Adapters::ActiveRecordQueries[
    initial_state: :eligibility_in_progress,
    transition_class: FormAnswerTransition
  ]
  include PgSearch::Model
  extend Enumerize
  include FormAnswerStatesHelper
  include FormAnswerAppraisalFormHelpers
  include RegionHelper

  POSSIBLE_AWARDS = ["qavs"]

  has_paper_trail

  attr_accessor :current_step, :validator_errors, :steps_with_errors

  pg_search_scope :basic_search,
                  against: [
                    :company_or_nominee_name,
                    :nominee_full_name,
                    :user_full_name,
                    :user_email
                  ],
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  mount_uploader :pdf_version, FormAnswerPdfVersionUploader

  enumerize :ineligible_reason_nominator, in: %w(involved_in_group no_knowledge no_letters_of_support)
  enumerize :ineligible_reason_group, in: %w(less_than_3_people outside_uk in_operation_for_less_than_3_years volunteers_not_eligible_to_reside_in_uk led_by_paid_stuff no_specific_benefit unsuccessful_in_the_past_3_years has_qavs_award benefits_only_animals)
  enumerize :sub_group, in: Assessor::SUBGROUPS

  begin :associations
    belongs_to :user
    belongs_to :account, optional: true
    belongs_to :award_year, optional: true
    belongs_to :company_details_editable, polymorphic: true, optional: true
    belongs_to :ceremonial_county, optional: true

    has_one :form_basic_eligibility, class_name: 'Eligibility::Basic', dependent: :destroy
    has_one :feedback, dependent: :destroy
    has_one :draft_note, as: :notable, dependent: :destroy
    has_one :palace_invite, dependent: :destroy
    has_one :citation, dependent: :destroy
    has_one :form_answer_progress, dependent: :destroy
    has_one :admin_verdict, dependent: :destroy
    has_one :group_leader

    belongs_to :primary_assessor, class_name: "Assessor", foreign_key: :primary_assessor_id, optional: true
    belongs_to :secondary_assessor, class_name: "Assessor", foreign_key: :secondary_assessor_id, optional: true
    has_many :form_answer_attachments, dependent: :destroy
    has_many :support_letter_attachments, dependent: :destroy

    has_many :audit_logs, as: :auditable
    has_many :support_letters, dependent: :destroy
    has_many :comments, as: :commentable, dependent: :destroy
    has_many :form_answer_transitions, autosave: false
    has_many :assessor_assignments, dependent: :destroy
    has_many :assessors, foreign_key: :sub_group, primary_key: :sub_group
  end

  begin :validations
    validates :user, presence: true
    validates :sic_code, format: { with: SicCode::REGEX }, allow_nil: true, allow_blank: true
    validate :validate_answers
    validates :ineligible_reason_nominator, presence: true, if: proc { state == "admin_not_eligible_nominator" }
    validates :ineligible_reason_group, presence: true, if: proc { state == "admin_not_eligible_group" }
  end

  begin :scopes
    scope :for_year, -> (year) { joins(:award_year).where(award_years: { year: year }) }
    scope :shortlisted, -> { where(state: "shortlisted") }
    scope :not_shortlisted, -> { where(state: "not_recommended") }
    scope :winners, -> { where(state: "awarded") }
    scope :unsuccessful_applications, -> { submitted.where("state not in ('awarded', 'withdrawn')") }
    scope :unsuccessful_applications_for_group_leader_mailer, -> { submitted.where(state: %w[local_assessment_recommended local_assessment_not_recommended not_recommended not_awarded]) }
    scope :unsuccessful_applications_for_nominator_mailer, -> { submitted.where(state: %w[local_assessment_recommended local_assessment_not_recommended not_recommended not_awarded]) }
    scope :submitted, -> { where.not(submitted_at: nil) }
    scope :positive, -> { where(state: FormAnswerStateMachine::POSITIVE_STATES) }
    scope :at_post_submission_stage, -> { where(state: FormAnswerStateMachine::POST_SUBMISSION_STATES) }
    scope :not_positive, -> { where(state: FormAnswerStateMachine::NOT_POSITIVE_STATES) }
    scope :in_progress, -> { where(state: ["eligibility_in_progress", "application_in_progress"]) }
    scope :eligible_for_lieutenant, -> { where(state: FormAnswerStatus::LieutenantFilter::OPTIONS.keys) }
    scope :eligible_for_assessor, -> { where(state: FormAnswerStatus::AssessorFilter::OPTIONS.keys) }
    scope :lieutenancy_assigned, -> { where.not(ceremonial_county_id: nil) }

    scope :past, -> {
      where(award_year_id: AwardYear.past.pluck(:id))
    }

    scope :hard_copy_generated, -> (mode) {
      submitted.where("#{mode}_hard_copy_generated" => true)
    }

    scope :with_comments_counters, -> {
      select("form_answers.*, COUNT(DISTINCT(comments.id)) AS comments_count, COUNT(DISTINCT(flagged_admin_comments.id)) AS flagged_admin_comments_count, COUNT(DISTINCT(flagged_critical_comments.id)) AS flagged_critical_comments_count")
        .joins("LEFT OUTER JOIN comments ON comments.commentable_id = form_answers.id AND comments.commentable_type = 'FormAnswer'")
        .joins("LEFT OUTER JOIN comments AS flagged_admin_comments ON flagged_admin_comments.commentable_id = form_answers.id AND flagged_admin_comments.commentable_type = 'FormAnswer' AND flagged_admin_comments.flagged IS true AND flagged_admin_comments.section = 0")
        .joins("LEFT OUTER JOIN comments AS flagged_critical_comments ON flagged_critical_comments.commentable_id = form_answers.id AND flagged_critical_comments.commentable_type = 'FormAnswer' AND flagged_critical_comments.flagged IS true AND flagged_critical_comments.section = 1")
    }

    scope :primary_and_secondary_appraisals_are_not_match, -> {
      where("discrepancies_between_primary_and_secondary_appraisals::text <> '{}'::text")
    }
  end

  begin :callbacks
    before_save :set_award_year, unless: :award_year
    before_save :set_progress
    before_save :set_region
    before_save :assign_searching_attributes
    before_save :assign_attributes_from_document

    before_create :set_account
    before_create :set_user_info
  end

  accepts_nested_attributes_for :support_letters, reject_if: :dismiss_support_letters

  store_accessor :document
  store_accessor :financial_data

  begin :state_machine
    delegate :current_state, :trigger!, :available_events, to: :state_machine
    delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
             to: :state_machine

    def state_machine
      @state_machine ||= FormAnswerStateMachine.new(self, transition_class: FormAnswerTransition)
    end
  end

  # FormAnswer#award_form
  # fetches relevant award form for the application's award year if available
  # else uses form for the current award year
  #
  # for the test environment uses current or previous year
  def award_form
    if award_year.present?
      form_class = if self.class.const_defined?(award_form_class_name(award_year.year))
        self.class.const_get(award_form_class_name(award_year.year))
      elsif self.class.const_defined?(award_form_class_name(AwardYear.current.year))
        self.class.const_get(award_form_class_name(AwardYear.current.year))
      elsif Rails.env.test?
        year = Date.current.year
        if self.class.const_defined?(award_form_class_name(year + 1))
          self.class.const_get(award_form_class_name(year + 1))
        elsif self.class.const_defined?(award_form_class_name(year))
          self.class.const_get(award_form_class_name(year))
        else
          AwardYears::V2027::QaeForms # default value
        end
      else
        raise ArgumentError, "Can not find award form for the nomination in year: #{award_year.year}"
      end

      form_class.qavs
    end
  end

  def eligible?
    eligibility && eligibility.eligible?
  end

  def eligibility
    form_basic_eligibility
  end

  def in_positive_state?
    FormAnswerStateMachine::POSITIVE_STATES.map(&:to_s).include?(state)
  end

  def from_previous_years?
    award_year.year < AwardYear.current.year
  end

  def document
    super || {}
  end

  def group_leader_first_name
    document['local_assessment_group_leader'].split(" ")[0]
  end

  def group_leader_last_name
    document['local_assessment_group_leader'].split(" ")[1..-1].join(" ")
  end

  def award_type
    "qavs"
  end

  def award_type_full_name
    "KAVS"
  end

  def head_of_business
    head_of_business = document["head_of_business_first_name"].to_s
    head_of_business += " "
    head_of_business += document["head_of_business_last_name"].to_s
  end

  def company_or_nominee_from_document
    comp_attr = 'nominee_name'
    name = document[comp_attr]
    name = nominee_full_name_from_document if name.blank?
    name = name.try(:strip)
    name.presence
  end

  def fill_progress_in_percents
    ((fill_progress || 0) * 100).round.to_s + "%"
  end

  def whodunnit
    PaperTrail.request.whodunnit
  end

  def submission_end_date
    award_year.settings
              .deadlines
              .submission_end
              .last
              .try(:trigger_at)
  end

  def local_assessment_end_date
    award_year.settings
              .deadlines
              .local_assessment_submission_end
              .last
              .try(:trigger_at)
  end

  def local_assessment_ended?
    local_assessment_end_date.present? && (Time.zone.now > local_assessment_end_date)
  end

  def submission_ended?
    submission_end_date.present? && (Time.zone.now > submission_end_date)
  end

  def version_before_deadline
    paper_trail.version_at(submission_end_date - 1.minute)
  end

  def original_form_answer
    submission_ended? ? version_before_deadline : self
  end

  def shortlisted?
    state == "shortlisted"
  end

  def was_marked_as_eligible?
    FormAnswerStateMachine::POST_ELIGIBLE_STATES.include?(state.to_sym)
  end

  def was_marked_as_ineligible?
    FormAnswerStateMachine::NOT_ELIGIBLE_STATES.include?(state.to_sym)
  end

  def was_marked_ll_recommended?
    FormAnswerStateMachine::POST_LA_POSITIVE_STATES.include?(state.to_sym)
  end

  #
  # Hard Copy PDF generators - begin
  #

  def generate_pdf_version!
    HardCopyGenerators::FormDataGenerator.new(self).run
  end

  def generate_pdf_version_from_latest_doc!
    HardCopyGenerators::FormDataGenerator.new(self, true).run
  end

  def generate_case_summary_hard_copy_pdf!
    HardCopyGenerators::CaseSummaryGenerator.new(self).run
  end

  def generate_feedback_hard_copy_pdf!
    HardCopyGenerators::FeedbackGenerator.new(self).run
  end

  def hard_copy_ready_for?(mode)
    send("#{mode}_hard_copy_generated?") &&
    send("#{mode}_hard_copy_pdf").present? &&
    send("#{mode}_hard_copy_pdf").file.present?
  end

  #
  # Hard Copy PDF generators - end
  #

  def unsuccessful_app?
    !awarded? && !withdrawn?
  end

  def collaborators
    account && account.collaborators_with(user)
  end

  def has_more_than_one_contributor?
    collaborators.count > 1
  end

  def palace_invite_submitted
    palace_invite.try(:submitted) ? 'Yes' : 'No'
  end

  def submitted?
    submitted_at.present?
  end

  # SIC code helpers
  #
  def sic_code=(code)
    if code.present?
      document["sic_code"] = code
    end
  end

  def sic_code
    document["sic_code"]
  end

  def previous_wins
    if document["applied_for_queen_awards_details"]
      document["applied_for_queen_awards_details"].select { |a| a["outcome"] == "won" }
    elsif document["queen_award_holder_details"]
      document["queen_award_holder_details"]
    else
      []
    end
  end

  def agree_sharing_of_details_with_lieutenancies?
    user.agree_sharing_of_details_with_lieutenancies ? "Yes" : "No"
  end

  def final_state?
    FormAnswerStateMachine::FINAL_VERDICT_STATES.include?(state.to_sym)  end

  def active_support_letters
    @active_support_letters ||= begin
      list = document["supporter_letters_list"] || [{}]
      ids = list.map { |dl| dl["support_letter_id"].to_i }

      support_letters.select do |sl|
        ids.include?(sl.id)
      end
    end
  end

  private

  def set_award_year
    self.award_year = AwardYear.current
  end

  def set_progress
    progress_hash = HashWithIndifferentAccess.new(document || {})
    form = award_form.decorate(answers: progress_hash)
    self.fill_progress = form.required_visible_questions_filled.to_f / form.required_visible_questions_total

    unless new_record?
      progress = (form_answer_progress || build_form_answer_progress)
      progress.assign_sections(form)
      progress.save
    end
    true
  end

  def set_region
    county = document["organization_address_county"]
    document["organization_address_region"] = lookup_region_for_county(county.to_sym) unless county.nil?
  end

  def assign_searching_attributes
    self.company_or_nominee_name = company_or_nominee_from_document
    self.nominee_full_name = nominee_full_name_from_document
  end

  def nominee_full_name_from_document
    "#{document['nominee_info_first_name']} #{document['nominee_info_last_name']}".strip
  end

  def assign_attributes_from_document
    self.nominee_activity = document["nominee_activity"]
    self.nominator_full_name = document["nominator_name"]
    self.nominator_email = document["nominator_email"]
    self.secondary_activity = document["secondary_activity"]
  end

  def set_account
    self.account = user.account
  end

  def set_user_info
    if user.present?
      self.user_full_name ||= user.full_name
      self.user_email ||= user.email
    end
  end

  def validate_answers
    if submitted? && (current_step || (submitted_at_changed? && submitted_at_was.nil?))
      validator = FormAnswerValidator.new(self)

      unless validator.valid?
        if Rails.env.test?
          # Better output in Test env
          # Or during the import from QAVSv1
          # so that devs can easily detect the reasons of issues!
          errors.add(:base, "Answers invalid! Errors: #{validator.errors.inspect}")
        else
          errors.add(:base, "Answers invalid")
        end

        self.validator_errors = validator.errors
      end
    end
  end

  def award_form_class_name(year)
    "::AwardYears::V#{year}::QaeForms"
  end

  def dismiss_support_letters(attributes)
    %w(first_name last_name relationship_to_nominee).all? { |attr| attributes[attr].blank? }
  end

  def self.transition_class
    FormAnswerTransition
  end

  def self.initial_state
    FormAnswerStateMachine.initial_state
  end
end
