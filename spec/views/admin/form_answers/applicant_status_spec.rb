# require "rails_helper"

# describe "applicant_status.html.slim" do
#   before do
#     enable_pundit(view, create(:admin))
#   end

#   context "eligiblity status" do
#     it "is pending" do
#       form_answer = create(:form_answer, :submitted)

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("PENDING")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is eligible" do
#       form_answer = create(:form_answer, :submitted, state: "admin_eligible")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("ELIGIBLE")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is eligible duplicate" do
#       form_answer = create(:form_answer, :submitted, state: "admin_eligible_duplicate")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("ELIGIBLE - DUPLICATE TO ACCESS")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is ineligible duplicate" do
#       form_answer = create(:form_answer, :submitted, state: "admin_not_eligible_duplicate")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("DUPLICATE FOR REFERENCE")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is ineligible because of the nominator" do
#       form_answer = create(:form_answer, :submitted, state: "admin_not_eligible_nominator", ineligible_reason_nominator: "no_letters_of_support")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("INELIGIBLE - NOMINATOR")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is ineligible because of the group" do
#       form_answer = create(:form_answer, :submitted, state: "admin_not_eligible_group", ineligible_reason_group: "no_specific_benefit")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("INELIGIBLE - GROUP")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "withdrawn" do
#       form_answer = create(:form_answer, :submitted, state: "admin_not_eligible_group", ineligible_reason_group: "no_specific_benefit")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("INELIGIBLE - GROUP")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end
#   end

#   context "local assessment status" do
#     it "is not started" do
#       form_answer = create(:form_answer, :submitted, state: "admin_eligible")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("ELIGIBLE")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT STARTED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is in progress" do
#       form_answer = create(:form_answer, :submitted, state: "local_assessment_in_progress")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("ELIGIBLE")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("IN PROGRESS")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is not recommended" do
#       form_answer = create(:form_answer, :submitted, state: "local_assessment_not_recommended")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("ELIGIBLE")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("NOT RECOMMENDED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end

#     it "is recommended" do
#       form_answer = create(:form_answer, :submitted, state: "local_assessment_recommended")

#       render partial: "admin/form_answers/applicant_status",
#              locals: {
#                resource: form_answer.decorate
#              }

#       within "#eligibility-status" do
#         rendered.should contain("ELIGIBLE")
#       end

#       within "#local-assessment-status" do
#         rendered.should contain("RECOMMENDED")
#       end

#       within "#national-assessment-status" do
#         rendered.should contain("PENDING")
#       end
#     end
#   end

#   context "national assessment status" do
#     pending
#   end
# end
