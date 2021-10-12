module NomineeActivityHelper

  ACTIVITY_MAPPINGS = {
    "ART": "Arts",
    "EDU": "Education",
    "EME": "Emergency response",
    "ENV": "Environment & regeneration",
    "HEA": "Health",
    "HER": "Heritage",
    "OTH": "Other",
    "PLY": "Playscheme/youth",
    "SUP": "Self help/support group",
    "SOC": "Social centre/community",
    "SPS": "Social preventative scheme",
    "SPO": "Sports"
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
