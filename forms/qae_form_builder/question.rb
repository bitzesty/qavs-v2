class QaeFormBuilder
  class QuestionValidator
    # multifield questions that can not be simply validated
    SKIP_PRESENCE_VALIDATION_QUESTIONS = [
      "DateQuestion",
      "AddressQuestion",
      "ByYearsQuestion",
      "ByYearsLabelQuestion",
      "OneOptionByYearsQuestion",
      "OneOptionByYearsLabelQuestion",
      "UserInfoQuestion",
      "SupportersQuestion",
    ]

    attr_reader :question, :answers

    def initialize(question, answers = {})
      @question = question
      @answers = answers
    end

    def errors
      result = {}

      return {} if skip_base_validation?

      if question.required?
        if !question.input_value.present?
          result[question.hash_key] = "Can't be blank."
        end
      end

      result
    end

    private

    def skip_base_validation?
      SKIP_PRESENCE_VALIDATION_QUESTIONS.any? do |klass|
        question.delegate_obj.class.name.demodulize == klass
      end
    end

    def limit_with_buffer(limit)
      if limit > 15
        (limit + limit * 0.1).to_i + 1
      else
        limit
      end
    end
  end

  class QuestionDecorator < QaeDecorator
    def input_name options = {}
      if options[:index]
        suffix = options.fetch(:suffix)
        "#{form_name}[#{delegate_obj.key}][#{options[:index]}][#{suffix}]"
      else
        "#{form_name}[#{hash_key(options)}]"
      end
    end

    def input_value options = {}
      result = if options[:index]
        suffix = options.fetch(:suffix)
        json = answers[delegate_obj.key] || {}
        json[options[:index]][suffix]
      else
        answers[hash_key(options)]
      end

      if options[:json]
        result || {}
      else
        result
      end
    end

    def required_sub_fields
      []
    end

    def array_answer
      false
    end

    def answers
      @decorator_options.fetch(:answers)
    end

    def form_name
      @decorator_options[:form_name] || 'form'
    end

    def hash_key options = {}
      options[:suffix] ? "#{delegate_obj.key}_#{options[:suffix]}" : delegate_obj.key
    end

    def label_as_legend?
      type = delegate_obj.class.name.demodulize.underscore

      legend_types = [
        "header_question",
        "options_question",
        "checkbox_seria_question",
        "confirm_question",
        "address_question",
        "assessor_details_question",
        "comment_question"
      ]

      legend_types.include?(type)
    end

    def fieldset_classes
      result = ["question-block",
       "js-conditional-answer"]
      result << delegate_obj.classes if delegate_obj.classes
      result << "question-required" if delegate_obj.required
      result << "js-conditional-drop-answer" if delegate_obj.drop_condition.present?
      result << "js-conditional-drop-block-answer" if delegate_obj.drop_block_condition
      result
    end

    def fieldset_data_hash
      result = {answer: delegate_obj.parameterized_title}

      if delegate_obj.drop_condition.present?
        result['drop-question'] = Array.wrap(delegate_obj.drop_condition).map do |k|
          delegate_obj.form[k].parameterized_title
        end.join(',')
      end

      result
    end

    def has_drops?
      if delegate_obj.drop_condition_parent.present?
        step.questions.select do |q|
          q.drop_condition.present? &&
          Array.wrap(q.drop_condition).include?(key)
        end.any? do |q|
          q.has_drops?
        end
      end
    end

    def validate
      errors = {}

      if visible?
        error = {}

        question_class = delegate_obj.class.name.demodulize
        validator_class = "QaeFormBuilder::#{question_class}Validator".constantize

        validator = validator_class.new(self, answers)
        errors.merge!(validator.errors)

        errors.merge!(error)
      end

      errors
    end

    def required?
      delegate_obj.required
    end

    def have_conditional_parent?
      delegate_obj.conditions.any?
    end

    def visible?(fetched_answers=nil)
      dc = delegate_obj.drop_condition_parent
      delegate_obj.conditions.
        all? do |condition|
          question_value = condition.question_value

          parent_question_answer = if fetched_answers.present?
            # Used in Reports::AllEntries, as passing json of answers
            # allows to make it faster
            fetched_answers[condition.question_key]
          else
            step.form[condition.question_key].input_value
          end

          if question_value == :true
            parent_question_answer.present?
          else
            parent_question_answer == question_value.to_s
          end
        end &&
      (!dc || (dc.present? && has_drops?))
    end

    def required_visible?
      required? && visible?
    end

    def required_visible_filled?
      return false unless required_visible?

      if required_sub_fields.blank?
        if respond_to?(:active_fields)
          active_fields.all? { |s| input_value(suffix: s).present? }
        else
          input_value.present?
        end
      else
        required_sub_fields.all? { |s| input_value(suffix: s.keys.first).present? }
      end
    end

    def escaped_title
      r_title = ''
      title = delegate_obj.title
      pdf_title = delegate_obj.pdf_title
      main_header = delegate_obj.main_header if delegate_obj.respond_to?(:main_header)

      r_title = title if title.present?
      r_title = pdf_title if r_title.blank? && pdf_title.present?
      r_title = main_header if r_title.blank? && main_header.present?

      prepared_text(r_title)
    end

    def escaped_context
      content = if delegate_obj.pdf_context.present?
        delegate_obj.pdf_context
      else
        delegate_obj.context
      end

      prepared_text(content) if content.present?
    end

    def escaped_help(h_text)
      prepared_text(h_text)
    end

    def prepared_text(content)
      Sanitize.fragment(content, elements: ["strong"], :parser_options => {
        max_errors: -1,
        max_tree_depth: -1
      }).strip
    end

    # Detects children conditions, grouped by option
    # We us it for detecting conditional hints for Form and in PDF
    def children_conditions(questions_with_references)
      questions_with_references.map do |q|
        q.conditions.select do |c|
          c.question_key == key
        end
      end.reject { |c| c.blank? }
         .flatten
         .reject { |q| q.question_value == :true }
         .group_by { |a| a.question_value }
    end

    def can_have_conditional_hints?
      delegate_obj.is_a?(QaeFormBuilder::OptionsQuestion)
    end

    def can_have_parent_conditional_hints?
      !delegate_obj.is_a?(QaeFormBuilder::HeaderQuestion)
    end

    def pdf_conditional_hints(questions_with_references)
      refs_and_values = conditions.map do |condition|
        parent_q = questions_with_references.detect do |q|
          q.key == condition.question_key
        end

        parent_ref = parent_q.ref.present? ? parent_q.ref : parent_q.sub_ref
        [parent_ref.to_s.delete(' '), condition.question_value]
      end

      pdf_hints = refs_and_values.map do |parent_ref, parent_val|
        if parent_ref.present?
          if parent_val.to_s != "true"
            "if you selected '#{parent_val.capitalize}' in question #{parent_ref}"
          end
        else
          "if you selected '#{parent_val.capitalize}' in previous question"
        end
      end

      "Answer this question #{pdf_hints.compact.join(" and ")}." if pdf_hints.any?
    end

    def conditional_hint(child_condition, questions_with_references)
      option_name = child_condition[0].to_s
                                      .split("_")
                                      .join(" ")
                                      .capitalize

      dependencies = child_condition[1].map do |c|
        parent_q = questions_with_references.detect do |q|
          q.key == c.parent_question_key
        end

        res = parent_q.ref.present? ? parent_q.ref : parent_q.sub_ref
        res.delete(' ')
      end

      generate_hint(option_name, dependencies)
    end

    def generate_hint(option_name, dependencies)
      "If #{option_name}, please answer the questions #{dependencies.to_sentence}"
    end
  end

  class QuestionBuilder
    def initialize q
      @q = q
    end

    def pdf_title text
      @q.pdf_title = text
    end

    def context text
      @q.context = text
    end

    def online_context text
      @q.online_context = text
    end

    def pdf_context text
      @q.pdf_context = text
    end

    def pdf_context_with_header_blocks text
      @q.pdf_context_with_header_blocks = text
    end

    def additional_pdf_context text
      @q.additional_pdf_context = text
    end

    def classes text
      @q.classes = text
    end

    def ref id
      @q.ref = id
    end

    def sub_ref id
      @q.sub_ref = id
    end

    def question_sub_title str
      @q.question_sub_title = str
    end

    def display_sub_ref_on_js_form(mode)
      @q.display_sub_ref_on_js_form = mode
    end

    def show_ref_always(mode)
      @q.show_ref_always = mode
    end

    def required
      @q.required = true
    end

    def help title, text
      @q.help << QuestionHelp.new(title, text)
    end

    def hint title, text
      @q.hint << QuestionHelp.new(title, text)
    end

    def form_hint text
      @q.form_hint = text
    end

    def conditional key, value
      @q.conditions << QuestionCondition.new(@q.key, key, value)
    end

    #
    # Use of drop_conditional:
    #
    # can be used just 1 key, like:
    #
    #   drop_conditional :drops_in_sales
    #
    # or can be used multiple parent conditional keys, like:
    #
    #   drop_conditional [:drops_in_turnover, :drops_explain_how_your_business_is_financially_viable]
    #
    def drop_conditional(keys)
      @q.drop_condition = keys
    end

    def drop_block_conditional
      @q.drop_block_condition = true
    end

    def drop_condition_parent
      @q.drop_condition_parent = true
    end

    def header header
      @q.header = header
    end

    def header_context header_context
      @q.header_context = header_context
    end
  end

  QuestionCondition = Struct.new(:parent_question_key, :question_key, :question_value)

  QuestionHelp = Struct.new(:title, :text)

  class Question
    attr_accessor :step,
                  :key,
                  :title,
                  :pdf_title,
                  :context,
                  :online_context,
                  :pdf_context,
                  :pdf_context_with_header_blocks,
                  :additional_pdf_context,
                  :opts,
                  :required,
                  :help,
                  :hint,
                  :form_hint,
                  :ref,
                  :sub_ref,
                  :question_sub_title,
                  :display_sub_ref_on_js_form,
                  :show_ref_always,
                  :conditions,
                  :header,
                  :header_context,
                  :classes,
                  :drop_condition,
                  :drop_condition_parent,
                  :drop_block_condition

    def initialize step, key, title, opts={}
      @step = step
      @key = key
      @title = title
      @opts = opts
      @required = false
      @help = []
      @hint = []
      @conditions = []
      @display_sub_ref_on_js_form = true
      @show_ref_always = false

      self.after_create if self.respond_to?(:after_create)
    end

    def context
      if @context.respond_to?(:call)
        @context.call
      else
        @context
      end
    end

    def title
      if @title.respond_to?(:call)
        @title.call
      else
        @title
      end
    end

    def decorate options = {}
      kls_name = self.class.name.split('::').last
      kls = QaeFormBuilder.const_get "#{kls_name}Decorator" rescue nil
      (kls || QuestionDecorator).new self, options
    end

    def form
      step.form
    end

    def parameterized_title
      key.to_s + "-" + title.parameterize
    end
  end
end
