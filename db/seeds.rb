require 'securerandom'

unless Admin.exists?
  admin_args = {
    email: "admin@example.com",
    password: SecureRandom.alphanumeric(12),
    first_name: "First name",
    last_name: "Last name",
    confirmed_at: DateTime.now
  }

  Admin.create!(admin_args)
  p "========Admin created========"
end

unless Assessor.exists?
  assessor_args = {
    email: "assessor@example.com",
    sub_group: "sub_group_1",
    password: SecureRandom.alphanumeric(12),
    first_name: "First name",
    last_name: "Last name",
    confirmed_at: DateTime.now
  }

  Assessor.create!(assessor_args)
  p "========Assessor created========"
end

unless CeremonialCounty.exists?
  %w(Berkshire Cumbria Warwickshire).each do |name|
    CeremonialCounty.create!(name: name)
  end
end
