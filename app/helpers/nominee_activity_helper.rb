module NomineeActivityHelper

  ACTIVITY_MAPPINGS = {
    "ARM": "Armed Forces",
    "ART": "Arts and Media",
    "ASY": "Asylum Seekers and Refugees",
    "PLY": "Children and Young People",
    "SOC": "Community Hubs and Services",
    "CUL": "Cultural",
    "DIS": "Disability",
    "EDU": "Education and Employment",
    "EME": "Emergency Response",
    "ENV": "Environment",
    "EVE": "Events",
    "FAM": "Family Support",
    "FOO": "Food Support",
    "HEA": "Health and Care",
    "HER": "Heritage",
    "HOM": "Homelessness",
    "SUP": "Mental Health and Wellbeing",
    "OLD": "Older People",
    "SPS": "Social Justice",
    "SPO": "Sport",
    "OTH": "Other"
  }

  def self.nominee_activities
    ACTIVITY_MAPPINGS.keys.sort
  end

  def self.nominee_activity_labels
    ACTIVITY_MAPPINGS.values.sort
  end

  def self.lookup_label_for_activity(activity)
    ACTIVITY_MAPPINGS[activity]
  end

  def self.lookup_key_for_label(activity)
    ACTIVITY_MAPPINGS.detect { |k, v| v == activity }.try(:first)
  end
end
