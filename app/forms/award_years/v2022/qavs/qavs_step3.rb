class AwardYears::V2022::QAEForms
  class << self
    def qavs_step3
      @qavs_step3 ||= proc do
        supporters :supporter_letters_list, "" do
          ref "C 1"
          context %(
            <p>Please obtain two different letters that endorse the nominated group's contribution from people who are familiar with its work.</p>
            <p>
              Supporters must not be volunteers or paid workers in the group. Each letter should be no more than 500 words. The letters should be about the whole group, rather than just one volunteer and should help to show <u>how</u> its work is outstanding. 
            </p>
            <p>Please list below the names of the supporters and their relationship (if any) to the group.</p>
          )
          hint "What are the allowed file formats?", %(
            <p>
              Letters of support must be uploaded as PDF documents when submitting this form.
            </p>
          )
          classes "question-support-uploads"
          limit 2
          default 1
          list_type :manual_upload
        end
      end
    end
  end
end
