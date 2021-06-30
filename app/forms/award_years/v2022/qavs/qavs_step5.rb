# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step5
      @qavs_step5 ||= proc do
        header :lieutenants_header, "Lieutenants part of the form" do
          ref "E 1"
        end

        textarea :lieutenant_verdict, "Verdict" do
          sub_ref "E 1.1"
          classes "sub-question"
          required
        end

        submit "Submit application" do
          notice %(
            <p>
              If you have answered all the questions, you can submit your application now. You will be able to edit it any time before [LIEUTENANT_SUBMISSION_ENDS_TIME].
            </p>
            <p>
              If you are not ready to submit yet, you can save your application and come back later.
            </p>
          )
        end
      end
    end
  end
end
