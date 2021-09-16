Rails.application.routes.draw do
  resource :healthcheck, only: :show

  # Content Security Policy report_uri (http://content-security-policy.com/)
  post "/csp_report_uri", to: "csp_report_uri#report"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    sessions: "sessions"
  }

  devise_for :admins, controllers: {
    confirmations: "admins/confirmations",
    devise_authy: "admin/devise_authy"
  }, path_names: {
    verify_authy: "/verify-token",
    enable_authy: "/enable-two-factor",
    verify_authy_installation: "/verify-installation",
    sessions: "sessions"
  }

  devise_for :lieutenants, controllers: {
    confirmations: "lieutenants/confirmations",
    passwords: "lieutenants/passwords",
    sessions: "sessions"
  }

  devise_for :assessors, controllers: {
    confirmations: "assessors/confirmations",
    sessions: "sessions"
  }

  devise_for :group_leaders, controllers: {
    confirmations: "group_leaders/confirmations",
    sessions: "sessions"
  }

  get "/awards_for_organisations"                       => redirect("https://www.gov.uk/queens-awards-for-enterprise/business-awards")
  get "/enterprise_promotion_awards"                    => redirect("https://www.gov.uk/queens-awards-for-enterprise/enterprise-promotion-award")
  get "/how_to_apply"                                   => redirect("https://www.gov.uk/queens-awards-for-enterprise/how-to-apply")
  get "/timeline"                                       => redirect("https://www.gov.uk/queens-awards-for-enterprise/timeline")
  get "/additional_information_and_contact"             => redirect("https://www.gov.uk/queens-awards-for-enterprise/how-to-apply")
  get "/apply-for-queens-award-for-enterprise"          => redirect("https://www.gov.uk/apply-queens-award-enterprise")
  get "/privacy"                                        => redirect("https://qavs.dcms.gov.uk/privacy-policy/")

  get "/sign_up_complete"                               => "content_only#sign_up_complete",                               as: "sign_up_complete"
  get "/cookies"                                        => "content_only#cookies",                                        as: "cookies"

  get  "/new_qavs_form"                                 => "form#new_qavs_form",                                          as: "new_qavs_form"

  get  "/form/:id"                                      => "form#edit_form",                                              as: "edit_form"
  post "/form/:id"                                      => "form#save",                                                   as: "save_form"
  post "/form/:id/attachments"                          => "form#add_attachment",                                         as: "attachments"
  get  "/form/:id/confirmation"                         => "form#submit_confirm",                                         as: "submit_confirm"
  get "/dashboard"                                      => "content_only#dashboard",                                      as: "dashboard"
  get "/guidance_notes"                                 => "content_only#pre_submission_guidance",                        as: "guidance_notes"

  get "/apply_qavs_award"                               => "content_only#apply_qavs_award",                               as: "apply_qavs_award"
  get "/award_info_qavs"                                => "content_only#award_info_qavs",                                as: "award_info_qavs"

  get "/award_winners_section"                          => "content_only#award_winners_section",                          as: "award_winners_section"

  root to: QAE.production? ? redirect("https://qavs.dcms.gov.uk") : "content_only#dashboard"

  resource :account, only: :show do
    collection do
      get :password_settings
      get :useful_information

      patch :update_password_settings
    end
  end

  resource :form_award_eligibility, only: [:show, :update] do
   collection do
      get :result
    end
  end

  resource :support_letter, only: [:new, :show, :create]
  resource :feedback, only: [:show, :create] do
    get :success
  end

  namespace :users do
    resources :form_answers, only: [:show] do
      resources :collaborator_access, only: [] do
        collection do
          get "auth/:section/:timestamp" => "collaborator_access#auth"
        end
      end

      resource :list_of_procedures, only: [:create, :destroy]
      resource :support_letter_attachments, only: :create
      resources :supporters, only: [:create, :destroy]
      resources :support_letters, only: [:create, :show, :destroy]
    end
    resources :form_answer_feedbacks, only: [:show]
  end

  resource :palace_invite, only: [:edit, :update]

  # NON JS implementation - begin
  namespace :form do
    resources :form_answers do
      resources :supporters, only: [:new, :create, :index, :destroy]
      resources :support_letters, only: [:new, :create, :destroy]
      resources :form_attachments, only: [:index, :new, :create, :destroy]
      resource :form_links, only: [:new, :create, :destroy]
      resources :organisational_charts, only: [:new, :create, :destroy] do
        get :confirm_deletion
      end
      resource :positions, only: [:new, :create, :edit, :update, :destroy] do
        get :index, on: :collection
      end

      [
        :awards,
        :subsidiaries
      ].each do |resource_name|
        resource resource_name, only: [:new, :create, :edit, :update, :destroy] do
          get :confirm_deletion
        end
      end
    end
  end
  # NON JS implementation - end

  namespace :assessor do
    root to: "form_answers#index"
    resources :palace_attendees, only: [:new, :create, :update, :destroy]
    resources :palace_invites, only: [] do
      member do
        post :submit
      end
    end

    resources :form_answers do
      collection do
        post :index
      end
      resources :form_answer_state_transitions, only: [:create]
      resources :form_answer_attachments, only: [:create, :show, :destroy]
      resources :support_letters, only: [:show]
      resources :list_of_procedures, only: [:show]
      resources :feedbacks, only: [:create, :update] do
        member do
          post :submit
          post :unlock
        end
      end

      member do
        patch :update_financials
        get :review
      end
      resources :draft_notes, only: [:create, :update]
    end

    resources :assessor_assignments, only: [:create, :update]
    resources :reports, only: [:index, :show]

    resources :assessment_submissions, only: [:create] do
      patch :unlock, on: :member
    end

    scope format: true, constraints: { format: 'json' } do
      resource :session_checks, only: [:show]
    end
  end

  namespace :admin do
    root to: "dashboard#index"
    get 'console', to: "admins#console"

    resources :dashboard, only: [:index] do
      collection do
        get :totals_by_month
        get :totals_by_week
        get :totals_by_day
        get :downloads
      end
    end

    resources :dashboard_reports, only: [] do
      collection do
        get :all_applications
        get :account_registrations
      end
    end

    resources :users, except: [:destroy] do
      member do
        patch :resend_confirmation_email
        patch :unlock
        patch :log_in
        post :scan_via_debounce_api
      end
    end
    resources :assessors
    resources :lieutenants
    resources :group_leaders, except: [:new, :create, :show]

    resources :admins do
      collection do
        # NOTE: debug abilities for Admin
        get :login_as_assessor
        get :login_as_user
      end
    end
    resources :reports, only: [:show] do
      get :import_csv_into_ms_excel_guide_pdf, on: :collection
    end
    resources :palace_attendees, only: [:new, :create, :update, :destroy]
    resources :palace_invites, only: [] do
      member do
        post :submit
      end
    end

    resources :form_answers do
      collection do
        post :index
        get :awarded_trade_applications
      end

      member do
        post :update_verdict
        post :save
        get :review
        get :eligibility
        patch :update_eligibility
      end

      resources :form_answer_state_transitions, only: [:create]
      resources :comments
      resources :form_answer_attachments, only: [:create, :show, :destroy]
      resources :support_letters, only: [:show]
      resources :list_of_procedures, only: [:show]
      resources :draft_notes, only: [:create, :update]
    end

    resource :settings, only: [:show] do
      resources :deadlines, only: [:update]
      resources :email_notifications, only: [:create, :update, :destroy] do
        collection do
          post :run_notifications
        end
      end

      member do
        post :bulk_award_nominations
      end
    end

    resources :assessor_assignments, only: [:create, :update]
    resources :assessment_submissions, only: [:create] do
      patch :unlock, on: :member
    end

    resource :users_feedback, only: [:show]
    resources :audit_logs, only: :index

    scope format: true, constraints: { format: 'json' } do
      resource :session_checks, only: [:show]
    end

    resources :lieutenant_assignment_collections, only: [:create]
    resources :assessor_assignment_collections, only: [:create]
  end

  namespace :lieutenant do
    root to: "dashboard#show"

    resources :lieutenants, except: [:show]
    resources :form_answers, only: [:index, :show, :edit] do
      collection do
        post :index
      end
      member do
        post :save
      end

      resources :form_answer_state_transitions, only: [:create]
      resources :support_letters, only: [:show]
    end
  end

  namespace :group_leader do
    root to: "dashboard#show"

    resources :citations, only: [:edit, :update]
  end
end
