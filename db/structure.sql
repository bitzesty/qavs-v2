SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_id integer
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: admin_verdicts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_verdicts (
    id bigint NOT NULL,
    outcome character varying,
    description text,
    form_answer_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: admin_verdicts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_verdicts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_verdicts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_verdicts_id_seq OWNED BY public.admin_verdicts.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    authy_id character varying,
    last_sign_in_with_authy timestamp without time zone,
    authy_enabled boolean DEFAULT false,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    superadmin boolean DEFAULT false,
    deleted boolean DEFAULT false,
    autosave_token character varying,
    unique_session_id character varying
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: assessor_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessor_assignments (
    id integer NOT NULL,
    form_answer_id integer NOT NULL,
    assessor_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    document public.hstore,
    submitted_at timestamp without time zone,
    editable_type character varying,
    editable_id integer,
    assessed_at timestamp without time zone,
    locked_at timestamp without time zone,
    award_year_id integer,
    status character varying
);


--
-- Name: assessor_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessor_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessor_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessor_assignments_id_seq OWNED BY public.assessor_assignments.id;


--
-- Name: assessors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessors (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    telephone_number character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    company character varying,
    deleted boolean DEFAULT false,
    autosave_token character varying,
    unique_session_id character varying,
    qavs_role character varying,
    sub_group character varying
);


--
-- Name: assessors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessors_id_seq OWNED BY public.assessors.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    subject_id integer,
    subject_type character varying,
    action_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    auditable_id integer,
    auditable_type character varying
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: award_years; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.award_years (
    id integer NOT NULL,
    year integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    form_data_hard_copies_state character varying,
    case_summary_hard_copies_state character varying,
    feedback_hard_copies_state character varying,
    aggregated_case_summary_hard_copy_state character varying,
    aggregated_feedback_hard_copy_state character varying
);


--
-- Name: award_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.award_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: award_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.award_years_id_seq OWNED BY public.award_years.id;


--
-- Name: ceremonial_counties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ceremonial_counties (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    country character varying
);


--
-- Name: ceremonial_counties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ceremonial_counties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ceremonial_counties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ceremonial_counties_id_seq OWNED BY public.ceremonial_counties.id;


--
-- Name: citations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.citations (
    id bigint NOT NULL,
    group_name character varying,
    body text,
    completed_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    form_answer_id bigint
);


--
-- Name: citations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.citations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: citations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.citations_id_seq OWNED BY public.citations.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    commentable_id integer NOT NULL,
    commentable_type character varying NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    authorable_type character varying NOT NULL,
    authorable_id integer NOT NULL,
    section integer NOT NULL,
    flagged boolean DEFAULT false
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: deadlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deadlines (
    id integer NOT NULL,
    kind character varying,
    trigger_at timestamp without time zone,
    settings_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    states_triggered_at timestamp without time zone
);


--
-- Name: deadlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deadlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deadlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deadlines_id_seq OWNED BY public.deadlines.id;


--
-- Name: draft_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_notes (
    id integer NOT NULL,
    content text,
    notable_type character varying NOT NULL,
    notable_id integer NOT NULL,
    authorable_type character varying NOT NULL,
    authorable_id integer NOT NULL,
    content_updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: draft_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.draft_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draft_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.draft_notes_id_seq OWNED BY public.draft_notes.id;


--
-- Name: eligibilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eligibilities (
    id integer NOT NULL,
    account_id integer,
    answers public.hstore,
    passed boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying,
    form_answer_id integer
);


--
-- Name: eligibilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eligibilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eligibilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eligibilities_id_seq OWNED BY public.eligibilities.id;


--
-- Name: email_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_notifications (
    id integer NOT NULL,
    kind character varying,
    sent boolean,
    trigger_at timestamp without time zone,
    settings_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_notifications_id_seq OWNED BY public.email_notifications.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedbacks (
    id integer NOT NULL,
    form_answer_id integer,
    submitted boolean DEFAULT false,
    document public.hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    authorable_type character varying,
    authorable_id integer,
    locked_at timestamp without time zone,
    award_year_id integer
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedbacks_id_seq OWNED BY public.feedbacks.id;


--
-- Name: form_answer_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.form_answer_attachments (
    id integer NOT NULL,
    form_answer_id integer,
    file text,
    original_filename text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    attachable_id integer,
    attachable_type character varying,
    title character varying,
    restricted_to_admin boolean DEFAULT false,
    question_key character varying,
    file_scan_results character varying
);


--
-- Name: form_answer_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.form_answer_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answer_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.form_answer_attachments_id_seq OWNED BY public.form_answer_attachments.id;


--
-- Name: form_answer_progresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.form_answer_progresses (
    id integer NOT NULL,
    sections public.hstore,
    form_answer_id integer NOT NULL
);


--
-- Name: form_answer_progresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.form_answer_progresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answer_progresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.form_answer_progresses_id_seq OWNED BY public.form_answer_progresses.id;


--
-- Name: form_answer_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.form_answer_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata text DEFAULT '{}'::text,
    sort_key integer NOT NULL,
    form_answer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    most_recent boolean NOT NULL
);


--
-- Name: form_answer_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.form_answer_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answer_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.form_answer_transitions_id_seq OWNED BY public.form_answer_transitions.id;


--
-- Name: form_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.form_answers (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_id integer,
    urn character varying,
    submitted boolean DEFAULT false,
    fill_progress double precision,
    state character varying DEFAULT 'eligibility_in_progress'::character varying NOT NULL,
    company_or_nominee_name character varying,
    nominee_full_name character varying,
    user_full_name character varying,
    nickname character varying,
    financial_data public.hstore,
    accepted boolean DEFAULT false,
    company_details_updated_at timestamp without time zone,
    award_year_id integer NOT NULL,
    company_details_editable_id integer,
    company_details_editable_type character varying,
    primary_assessor_id integer,
    secondary_assessor_id integer,
    document json,
    nominee_title character varying,
    nominator_full_name character varying,
    nominator_email character varying,
    user_email character varying,
    corp_responsibility_reviewed boolean DEFAULT false,
    pdf_version character varying,
    mobility_eligibility_id integer,
    submitted_at timestamp without time zone,
    form_data_hard_copy_generated boolean DEFAULT false,
    case_summary_hard_copy_generated boolean DEFAULT false,
    feedback_hard_copy_generated boolean DEFAULT false,
    discrepancies_between_primary_and_secondary_appraisals json,
    nominee_activity character varying,
    ceremonial_county_id integer,
    ineligible_reason_nominator character varying,
    ineligible_reason_group character varying,
    sub_group character varying,
    secondary_activity character varying,
    oid character varying
);


--
-- Name: form_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.form_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.form_answers_id_seq OWNED BY public.form_answers.id;


--
-- Name: group_leaders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_leaders (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    deleted boolean DEFAULT false NOT NULL,
    form_answer_id integer
);


--
-- Name: group_leaders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_leaders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_leaders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_leaders_id_seq OWNED BY public.group_leaders.id;


--
-- Name: lieutenants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lieutenants (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    role character varying,
    lieutenants character varying,
    unique_session_id character varying,
    deleted boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    ceremonial_county_id integer,
    oid character varying
);


--
-- Name: lieutenants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lieutenants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lieutenants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lieutenants_id_seq OWNED BY public.lieutenants.id;


--
-- Name: nomination_searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nomination_searches (
    id bigint NOT NULL,
    serialized_query text
);


--
-- Name: nomination_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nomination_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nomination_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nomination_searches_id_seq OWNED BY public.nomination_searches.id;


--
-- Name: palace_attendees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.palace_attendees (
    id integer NOT NULL,
    title character varying,
    first_name character varying,
    last_name character varying,
    job_name character varying,
    post_nominals character varying,
    address_1 character varying,
    address_2 character varying,
    address_3 character varying,
    address_4 character varying,
    postcode character varying,
    phone_number character varying,
    additional_info text,
    palace_invite_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    relationship character varying,
    disabled_access boolean,
    preferred_date character varying,
    alternative_date character varying
);


--
-- Name: palace_attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.palace_attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: palace_attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.palace_attendees_id_seq OWNED BY public.palace_attendees.id;


--
-- Name: palace_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.palace_invites (
    id integer NOT NULL,
    email character varying,
    form_answer_id integer,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submitted boolean DEFAULT false
);


--
-- Name: palace_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.palace_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: palace_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.palace_invites_id_seq OWNED BY public.palace_invites.id;


--
-- Name: previous_wins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.previous_wins (
    id integer NOT NULL,
    form_answer_id integer NOT NULL,
    category character varying,
    year integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: previous_wins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.previous_wins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: previous_wins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.previous_wins_id_seq OWNED BY public.previous_wins.id;


--
-- Name: protected_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_files (
    id uuid NOT NULL,
    entity_type character varying,
    entity_id bigint,
    file character varying,
    created_at timestamp(6) without time zone NOT NULL,
    last_downloaded_at timestamp(6) without time zone
);


--
-- Name: scans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scans (
    id integer NOT NULL,
    uuid character varying NOT NULL,
    filename character varying,
    status character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    form_answer_attachment_id integer,
    support_letter_attachment_id integer,
    audit_certificate_id integer,
    vs_id character varying
);


--
-- Name: scans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scans_id_seq OWNED BY public.scans.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    award_year_id integer NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: site_feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_feedbacks (
    id integer NOT NULL,
    rating integer,
    comment text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: site_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.site_feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.site_feedbacks_id_seq OWNED BY public.site_feedbacks.id;


--
-- Name: support_letter_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.support_letter_attachments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    form_answer_id integer NOT NULL,
    attachment character varying,
    original_filename character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    support_letter_id integer,
    attachment_scan_results character varying
);


--
-- Name: support_letter_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.support_letter_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_letter_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.support_letter_attachments_id_seq OWNED BY public.support_letter_attachments.id;


--
-- Name: support_letters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.support_letters (
    id integer NOT NULL,
    supporter_id integer,
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    form_answer_id integer,
    first_name character varying,
    last_name character varying,
    organization_name character varying,
    phone character varying,
    relationship_to_nominee character varying,
    address_first character varying,
    address_second character varying,
    city character varying,
    country character varying,
    postcode character varying,
    manual boolean DEFAULT false
);


--
-- Name: support_letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.support_letters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.support_letters_id_seq OWNED BY public.support_letters.id;


--
-- Name: urn_seq_2015; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2015
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2016; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2016
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2017; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2017
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2018; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2018
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2019; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2019
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2020; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2020
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2021; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2021
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2022; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2022
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2023; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2023
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2024; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2024
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2025; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2025
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2026; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2026
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2027; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2027
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2028; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2028
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2029; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2029
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2030; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2030
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2031; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2031
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2032; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2032
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2033; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2033
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2034; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2034
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2035; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2035
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2036; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2036
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2037; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2037
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2038; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2038
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2039; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2039
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2040; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2040
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2041; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2041
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2042; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2042
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2043; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2043
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2044; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2044
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2045; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2045
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2046; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2046
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2047; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2047
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2048; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2048
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2049; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2049
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2050; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2050
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2051; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2051
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2052; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2052
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2053; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2053
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2054; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2054
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2055; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2055
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2056; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2056
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2057; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2057
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2058; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2058
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2059; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2059
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2060; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2060
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2061; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2061
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2062; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2062
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2063; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2063
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2064; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2064
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2065; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_2065
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2015; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2015
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2016; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2016
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2017; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2017
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2018; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2018
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2019; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2019
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2020; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2020
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2021; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2021
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2022; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2022
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2023; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2023
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2024; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2024
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2025; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2025
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2026; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2026
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2027; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2027
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2028; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2028
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2029; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2029
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2030; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2030
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2031; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2031
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2032; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2032
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2033; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2033
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2034; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2034
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2035; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2035
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2036; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2036
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2037; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2037
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2038; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2038
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2039; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2039
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2040; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2040
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2041; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2041
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2042; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2042
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2043; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2043
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2044; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2044
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2045; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2045
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2046; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2046
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2047; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2047
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2048; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2048
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2049; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2049
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2050; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2050
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2051; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2051
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2052; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2052
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2053; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2053
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2054; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2054
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2055; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2055
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2056; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2056
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2057; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2057
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2058; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2058
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2059; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2059
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2060; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2060
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2061; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2061
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2062; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2062
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2063; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2063
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2064; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2064
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2065; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urn_seq_promotion_2065
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying,
    first_name character varying,
    last_name character varying,
    job_title character varying,
    phone_number character varying,
    company_name character varying,
    company_address_first character varying,
    company_address_second character varying,
    company_city character varying,
    company_country character varying,
    company_postcode character varying,
    company_phone_number character varying,
    prefered_method_of_contact character varying,
    subscribed_to_emails boolean DEFAULT false,
    qae_info_source character varying,
    qae_info_source_other character varying,
    account_id integer,
    completed_registration boolean DEFAULT false,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    agree_being_contacted_by_department_of_business boolean DEFAULT false,
    imported boolean DEFAULT false,
    address_line1 character varying,
    address_line2 character varying,
    address_line3 character varying,
    postcode character varying,
    phone_number2 character varying,
    mobile_number character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    unique_session_id character varying,
    notification_when_submission_deadline_is_coming boolean DEFAULT false,
    agree_sharing_of_details_with_lieutenancies boolean
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: version_associations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.version_associations (
    id integer NOT NULL,
    version_id integer,
    foreign_key_name character varying NOT NULL,
    foreign_key_id integer
);


--
-- Name: version_associations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.version_associations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: version_associations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.version_associations_id_seq OWNED BY public.version_associations.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    object_changes json,
    created_at timestamp without time zone,
    transaction_id integer
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: admin_verdicts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_verdicts ALTER COLUMN id SET DEFAULT nextval('public.admin_verdicts_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: assessor_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessor_assignments ALTER COLUMN id SET DEFAULT nextval('public.assessor_assignments_id_seq'::regclass);


--
-- Name: assessors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessors ALTER COLUMN id SET DEFAULT nextval('public.assessors_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: award_years id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.award_years ALTER COLUMN id SET DEFAULT nextval('public.award_years_id_seq'::regclass);


--
-- Name: ceremonial_counties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ceremonial_counties ALTER COLUMN id SET DEFAULT nextval('public.ceremonial_counties_id_seq'::regclass);


--
-- Name: citations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citations ALTER COLUMN id SET DEFAULT nextval('public.citations_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: deadlines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deadlines ALTER COLUMN id SET DEFAULT nextval('public.deadlines_id_seq'::regclass);


--
-- Name: draft_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_notes ALTER COLUMN id SET DEFAULT nextval('public.draft_notes_id_seq'::regclass);


--
-- Name: eligibilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eligibilities ALTER COLUMN id SET DEFAULT nextval('public.eligibilities_id_seq'::regclass);


--
-- Name: email_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_notifications ALTER COLUMN id SET DEFAULT nextval('public.email_notifications_id_seq'::regclass);


--
-- Name: feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks ALTER COLUMN id SET DEFAULT nextval('public.feedbacks_id_seq'::regclass);


--
-- Name: form_answer_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answer_attachments ALTER COLUMN id SET DEFAULT nextval('public.form_answer_attachments_id_seq'::regclass);


--
-- Name: form_answer_progresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answer_progresses ALTER COLUMN id SET DEFAULT nextval('public.form_answer_progresses_id_seq'::regclass);


--
-- Name: form_answer_transitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answer_transitions ALTER COLUMN id SET DEFAULT nextval('public.form_answer_transitions_id_seq'::regclass);


--
-- Name: form_answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answers ALTER COLUMN id SET DEFAULT nextval('public.form_answers_id_seq'::regclass);


--
-- Name: group_leaders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_leaders ALTER COLUMN id SET DEFAULT nextval('public.group_leaders_id_seq'::regclass);


--
-- Name: lieutenants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lieutenants ALTER COLUMN id SET DEFAULT nextval('public.lieutenants_id_seq'::regclass);


--
-- Name: nomination_searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nomination_searches ALTER COLUMN id SET DEFAULT nextval('public.nomination_searches_id_seq'::regclass);


--
-- Name: palace_attendees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.palace_attendees ALTER COLUMN id SET DEFAULT nextval('public.palace_attendees_id_seq'::regclass);


--
-- Name: palace_invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.palace_invites ALTER COLUMN id SET DEFAULT nextval('public.palace_invites_id_seq'::regclass);


--
-- Name: previous_wins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.previous_wins ALTER COLUMN id SET DEFAULT nextval('public.previous_wins_id_seq'::regclass);


--
-- Name: scans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scans ALTER COLUMN id SET DEFAULT nextval('public.scans_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: site_feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_feedbacks ALTER COLUMN id SET DEFAULT nextval('public.site_feedbacks_id_seq'::regclass);


--
-- Name: support_letter_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letter_attachments ALTER COLUMN id SET DEFAULT nextval('public.support_letter_attachments_id_seq'::regclass);


--
-- Name: support_letters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letters ALTER COLUMN id SET DEFAULT nextval('public.support_letters_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: version_associations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.version_associations ALTER COLUMN id SET DEFAULT nextval('public.version_associations_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: admin_verdicts admin_verdicts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_verdicts
    ADD CONSTRAINT admin_verdicts_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assessor_assignments assessor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessor_assignments
    ADD CONSTRAINT assessor_assignments_pkey PRIMARY KEY (id);


--
-- Name: assessors assessors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessors
    ADD CONSTRAINT assessors_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: award_years award_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.award_years
    ADD CONSTRAINT award_years_pkey PRIMARY KEY (id);


--
-- Name: ceremonial_counties ceremonial_counties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ceremonial_counties
    ADD CONSTRAINT ceremonial_counties_pkey PRIMARY KEY (id);


--
-- Name: citations citations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: deadlines deadlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deadlines
    ADD CONSTRAINT deadlines_pkey PRIMARY KEY (id);


--
-- Name: draft_notes draft_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_notes
    ADD CONSTRAINT draft_notes_pkey PRIMARY KEY (id);


--
-- Name: eligibilities eligibilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eligibilities
    ADD CONSTRAINT eligibilities_pkey PRIMARY KEY (id);


--
-- Name: email_notifications email_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_notifications
    ADD CONSTRAINT email_notifications_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: form_answer_attachments form_answer_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answer_attachments
    ADD CONSTRAINT form_answer_attachments_pkey PRIMARY KEY (id);


--
-- Name: form_answer_progresses form_answer_progresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answer_progresses
    ADD CONSTRAINT form_answer_progresses_pkey PRIMARY KEY (id);


--
-- Name: form_answer_transitions form_answer_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answer_transitions
    ADD CONSTRAINT form_answer_transitions_pkey PRIMARY KEY (id);


--
-- Name: form_answers form_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_answers
    ADD CONSTRAINT form_answers_pkey PRIMARY KEY (id);


--
-- Name: group_leaders group_leaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_leaders
    ADD CONSTRAINT group_leaders_pkey PRIMARY KEY (id);


--
-- Name: lieutenants lieutenants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lieutenants
    ADD CONSTRAINT lieutenants_pkey PRIMARY KEY (id);


--
-- Name: nomination_searches nomination_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nomination_searches
    ADD CONSTRAINT nomination_searches_pkey PRIMARY KEY (id);


--
-- Name: palace_attendees palace_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.palace_attendees
    ADD CONSTRAINT palace_attendees_pkey PRIMARY KEY (id);


--
-- Name: palace_invites palace_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.palace_invites
    ADD CONSTRAINT palace_invites_pkey PRIMARY KEY (id);


--
-- Name: previous_wins previous_wins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.previous_wins
    ADD CONSTRAINT previous_wins_pkey PRIMARY KEY (id);


--
-- Name: protected_files protected_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_files
    ADD CONSTRAINT protected_files_pkey PRIMARY KEY (id);


--
-- Name: scans scans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scans
    ADD CONSTRAINT scans_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: site_feedbacks site_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_feedbacks
    ADD CONSTRAINT site_feedbacks_pkey PRIMARY KEY (id);


--
-- Name: support_letter_attachments support_letter_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letter_attachments
    ADD CONSTRAINT support_letter_attachments_pkey PRIMARY KEY (id);


--
-- Name: support_letters support_letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letters
    ADD CONSTRAINT support_letters_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: version_associations version_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.version_associations
    ADD CONSTRAINT version_associations_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_owner_id ON public.accounts USING btree (owner_id);


--
-- Name: index_admin_verdicts_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admin_verdicts_on_form_answer_id ON public.admin_verdicts USING btree (form_answer_id);


--
-- Name: index_admins_on_authy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_authy_id ON public.admins USING btree (authy_id);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_admins_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_unlock_token ON public.admins USING btree (unlock_token);


--
-- Name: index_assessor_assignments_on_assessor_id_and_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assessor_assignments_on_assessor_id_and_form_answer_id ON public.assessor_assignments USING btree (assessor_id, form_answer_id);


--
-- Name: index_assessor_assignments_on_award_year_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assessor_assignments_on_award_year_id ON public.assessor_assignments USING btree (award_year_id);


--
-- Name: index_assessors_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assessors_on_confirmation_token ON public.assessors USING btree (confirmation_token);


--
-- Name: index_assessors_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assessors_on_email ON public.assessors USING btree (email);


--
-- Name: index_assessors_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assessors_on_reset_password_token ON public.assessors USING btree (reset_password_token);


--
-- Name: index_assessors_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assessors_on_unlock_token ON public.assessors USING btree (unlock_token);


--
-- Name: index_award_years_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_award_years_on_year ON public.award_years USING btree (year);


--
-- Name: index_ceremonial_counties_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ceremonial_counties_on_name ON public.ceremonial_counties USING btree (name);


--
-- Name: index_citations_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_citations_on_form_answer_id ON public.citations USING btree (form_answer_id);


--
-- Name: index_comments_on_commentable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable_id ON public.comments USING btree (commentable_id);


--
-- Name: index_comments_on_commentable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable_type ON public.comments USING btree (commentable_type);


--
-- Name: index_deadlines_on_settings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deadlines_on_settings_id ON public.deadlines USING btree (settings_id);


--
-- Name: index_eligibilities_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_eligibilities_on_account_id ON public.eligibilities USING btree (account_id);


--
-- Name: index_eligibilities_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_eligibilities_on_form_answer_id ON public.eligibilities USING btree (form_answer_id);


--
-- Name: index_email_notifications_on_settings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_notifications_on_settings_id ON public.email_notifications USING btree (settings_id);


--
-- Name: index_feedbacks_on_award_year_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedbacks_on_award_year_id ON public.feedbacks USING btree (award_year_id);


--
-- Name: index_feedbacks_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedbacks_on_form_answer_id ON public.feedbacks USING btree (form_answer_id);


--
-- Name: index_form_answer_attachments_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_answer_attachments_on_form_answer_id ON public.form_answer_attachments USING btree (form_answer_id);


--
-- Name: index_form_answer_progresses_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_form_answer_progresses_on_form_answer_id ON public.form_answer_progresses USING btree (form_answer_id);


--
-- Name: index_form_answer_transitions_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_answer_transitions_on_form_answer_id ON public.form_answer_transitions USING btree (form_answer_id);


--
-- Name: index_form_answer_transitions_on_sort_key_and_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_form_answer_transitions_on_sort_key_and_form_answer_id ON public.form_answer_transitions USING btree (sort_key, form_answer_id);


--
-- Name: index_form_answer_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_form_answer_transitions_parent_most_recent ON public.form_answer_transitions USING btree (form_answer_id, most_recent) WHERE most_recent;


--
-- Name: index_form_answers_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_answers_on_account_id ON public.form_answers USING btree (account_id);


--
-- Name: index_form_answers_on_award_year_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_answers_on_award_year_id ON public.form_answers USING btree (award_year_id);


--
-- Name: index_form_answers_on_award_year_id_and_ceremonial_county_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_answers_on_award_year_id_and_ceremonial_county_id ON public.form_answers USING btree (award_year_id, ceremonial_county_id);


--
-- Name: index_form_answers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_answers_on_user_id ON public.form_answers USING btree (user_id);


--
-- Name: index_group_leaders_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_group_leaders_on_confirmation_token ON public.group_leaders USING btree (confirmation_token);


--
-- Name: index_group_leaders_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_group_leaders_on_email ON public.group_leaders USING btree (email);


--
-- Name: index_group_leaders_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_leaders_on_form_answer_id ON public.group_leaders USING btree (form_answer_id);


--
-- Name: index_group_leaders_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_group_leaders_on_reset_password_token ON public.group_leaders USING btree (reset_password_token);


--
-- Name: index_group_leaders_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_group_leaders_on_unlock_token ON public.group_leaders USING btree (unlock_token);


--
-- Name: index_lieutenants_on_ceremonial_county_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lieutenants_on_ceremonial_county_id ON public.lieutenants USING btree (ceremonial_county_id);


--
-- Name: index_lieutenants_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lieutenants_on_confirmation_token ON public.lieutenants USING btree (confirmation_token);


--
-- Name: index_lieutenants_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lieutenants_on_email ON public.lieutenants USING btree (email);


--
-- Name: index_lieutenants_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lieutenants_on_reset_password_token ON public.lieutenants USING btree (reset_password_token);


--
-- Name: index_lieutenants_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lieutenants_on_unlock_token ON public.lieutenants USING btree (unlock_token);


--
-- Name: index_palace_attendees_on_palace_invite_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_palace_attendees_on_palace_invite_id ON public.palace_attendees USING btree (palace_invite_id);


--
-- Name: index_palace_invites_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_palace_invites_on_form_answer_id ON public.palace_invites USING btree (form_answer_id);


--
-- Name: index_protected_files_on_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_files_on_entity ON public.protected_files USING btree (entity_type, entity_id);


--
-- Name: index_scans_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_scans_on_uuid ON public.scans USING btree (uuid);


--
-- Name: index_settings_on_award_year_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_settings_on_award_year_id ON public.settings USING btree (award_year_id);


--
-- Name: index_support_letter_attachments_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_support_letter_attachments_on_form_answer_id ON public.support_letter_attachments USING btree (form_answer_id);


--
-- Name: index_support_letter_attachments_on_support_letter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_support_letter_attachments_on_support_letter_id ON public.support_letter_attachments USING btree (support_letter_id);


--
-- Name: index_support_letter_attachments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_support_letter_attachments_on_user_id ON public.support_letter_attachments USING btree (user_id);


--
-- Name: index_support_letters_on_form_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_support_letters_on_form_answer_id ON public.support_letters USING btree (form_answer_id);


--
-- Name: index_support_letters_on_supporter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_support_letters_on_supporter_id ON public.support_letters USING btree (supporter_id);


--
-- Name: index_support_letters_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_support_letters_on_user_id ON public.support_letters USING btree (user_id);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_account_id ON public.users USING btree (account_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_version_associations_on_foreign_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_version_associations_on_foreign_key ON public.version_associations USING btree (foreign_key_name, foreign_key_id);


--
-- Name: index_version_associations_on_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_version_associations_on_version_id ON public.version_associations USING btree (version_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: index_versions_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_transaction_id ON public.versions USING btree (transaction_id);


--
-- Name: support_letter_attachments fk_rails_0f5a0025a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letter_attachments
    ADD CONSTRAINT fk_rails_0f5a0025a7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: admin_verdicts fk_rails_23f1653342; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_verdicts
    ADD CONSTRAINT fk_rails_23f1653342 FOREIGN KEY (form_answer_id) REFERENCES public.form_answers(id);


--
-- Name: palace_invites fk_rails_40aaf5af73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.palace_invites
    ADD CONSTRAINT fk_rails_40aaf5af73 FOREIGN KEY (form_answer_id) REFERENCES public.form_answers(id);


--
-- Name: support_letter_attachments fk_rails_5e975fee43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letter_attachments
    ADD CONSTRAINT fk_rails_5e975fee43 FOREIGN KEY (support_letter_id) REFERENCES public.support_letters(id);


--
-- Name: palace_attendees fk_rails_6019307b8c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.palace_attendees
    ADD CONSTRAINT fk_rails_6019307b8c FOREIGN KEY (palace_invite_id) REFERENCES public.palace_invites(id);


--
-- Name: feedbacks fk_rails_6ae522c6ce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT fk_rails_6ae522c6ce FOREIGN KEY (award_year_id) REFERENCES public.award_years(id);


--
-- Name: feedbacks fk_rails_85a1d7f049; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT fk_rails_85a1d7f049 FOREIGN KEY (form_answer_id) REFERENCES public.form_answers(id);


--
-- Name: support_letter_attachments fk_rails_abd43a0510; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letter_attachments
    ADD CONSTRAINT fk_rails_abd43a0510 FOREIGN KEY (form_answer_id) REFERENCES public.form_answers(id);


--
-- Name: assessor_assignments fk_rails_bed48e0ed5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessor_assignments
    ADD CONSTRAINT fk_rails_bed48e0ed5 FOREIGN KEY (award_year_id) REFERENCES public.award_years(id);


--
-- Name: support_letters fk_rails_fae9e85e5f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letters
    ADD CONSTRAINT fk_rails_fae9e85e5f FOREIGN KEY (form_answer_id) REFERENCES public.form_answers(id);


--
-- Name: support_letters fk_rails_fe9ef772b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_letters
    ADD CONSTRAINT fk_rails_fe9ef772b4 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250604124109'),
('20240819143818'),
('20240819123818'),
('20240216144428'),
('20211214111643'),
('20211104074415'),
('20211013073349'),
('20211011083451'),
('20210928120530'),
('20210831085355'),
('20210826124140'),
('20210819140008'),
('20210817084427'),
('20210816072005'),
('20210810175339'),
('20210810173827'),
('20210809073242'),
('20210809072320'),
('20210809072025'),
('20210808194051'),
('20210806102135'),
('20210803120605'),
('20210803084421'),
('20210707122554'),
('20210707115136'),
('20210707081708'),
('20210629130552'),
('20210616135647'),
('20210615093659'),
('20210517075551'),
('20201023115307'),
('20200918151320'),
('20200918110854'),
('20200814122259'),
('20200714125921'),
('20200710150405'),
('20190515121928'),
('20190514192116'),
('20190513114859'),
('20190501163901'),
('20190501162430'),
('20190501154629'),
('20190422174739'),
('20190415133209'),
('20181102125923'),
('20181102125508'),
('20180820050136'),
('20161116104612'),
('20161021140457'),
('20161021111201'),
('20160906174550'),
('20160804175527'),
('20160804175513'),
('20160804175341'),
('20160804172537'),
('20160802111557'),
('20160731121716'),
('20160731102944'),
('20160729132552'),
('20160729132247'),
('20160729131756'),
('20160729090515'),
('20160729082616'),
('20160729082206'),
('20160728174732'),
('20160728174708'),
('20160727154722'),
('20160708131227'),
('20160621114955'),
('20160607172315'),
('20160607085426'),
('20160604141333'),
('20160328124213'),
('20160328090616'),
('20160323103504'),
('20160314141838'),
('20160311130931'),
('20160310140650'),
('20160302191628'),
('20160302191611'),
('20160302191539'),
('20160224174712'),
('20160222175452'),
('20160222153821'),
('20160204203037'),
('20160121080201'),
('20160106115349'),
('20151130145800'),
('20151126171347'),
('20151126154434'),
('20151005112348'),
('20151001144155'),
('20150922132151'),
('20150917135114'),
('20150917134236'),
('20150914114817'),
('20150908172247'),
('20150908163040'),
('20150908151417'),
('20150908105756'),
('20150907165227'),
('20150907161006'),
('20150907145955'),
('20150907145343'),
('20150907131321'),
('20150622173914'),
('20150617142142'),
('20150519123524'),
('20150515145647'),
('20150507143136'),
('20150507114157'),
('20150506150526'),
('20150504112318'),
('20150429171705'),
('20150429171704'),
('20150429171132'),
('20150427100604'),
('20150417153811'),
('20150414170238'),
('20150414141823'),
('20150414133524'),
('20150414102640'),
('20150411113558'),
('20150411113543'),
('20150411113532'),
('20150411113516'),
('20150410131705'),
('20150410091747'),
('20150409090140'),
('20150409082247'),
('20150407172016'),
('20150407134028'),
('20150407132835'),
('20150407122134'),
('20150406130916'),
('20150331180118'),
('20150331061542'),
('20150327190410'),
('20150327122904'),
('20150326221536'),
('20150326170823'),
('20150326170750'),
('20150326105117'),
('20150325201007'),
('20150325160755'),
('20150325133040'),
('20150325092930'),
('20150324163344'),
('20150324104913'),
('20150324104816'),
('20150323155826'),
('20150323132637'),
('20150318142055'),
('20150318123932'),
('20150317130146'),
('20150313090152'),
('20150312114528'),
('20150312105021'),
('20150310130907'),
('20150310124624'),
('20150310114756'),
('20150309143448'),
('20150309114427'),
('20150309114102'),
('20150309112759'),
('20150306122216'),
('20150305104844'),
('20150305084628'),
('20150304155948'),
('20150304145423'),
('20150304144532'),
('20150304084018'),
('20150304080108'),
('20150304075824'),
('20150303163541'),
('20150303152052'),
('20150303123415'),
('20150303120704'),
('20150302095528'),
('20150302092030'),
('20150228145247'),
('20150227141437'),
('20150227135432'),
('20150227125421'),
('20150227125226'),
('20150227125140'),
('20150227124243'),
('20150226141107'),
('20150225122104'),
('20150225090728'),
('20150224115503'),
('20150224115303'),
('20150223123005'),
('20150223115842'),
('20150223100419'),
('20150219125327'),
('20150219102528'),
('20150218150006'),
('20150218141547'),
('20150218132412'),
('20150217114106'),
('20150216232552'),
('20150113155731'),
('20150113154435'),
('20150112121539'),
('20150109142716'),
('20141219102035'),
('20141217112332'),
('20141211103425'),
('20141211103406'),
('20141209150903'),
('20141208105812'),
('20141208085751'),
('20141204161223'),
('20141204134014'),
('20141204113729'),
('20141204113405'),
('20141203182047'),
('20141203172220'),
('20141203140154'),
('20141203135504'),
('20141203090803'),
('20141201084521'),
('20141130191608'),
('20141128115405'),
('20141127095334'),
('20141127094940'),
('20141127094914'),
('20141124161532'),
('20141124112326'),
('20141124095215');
