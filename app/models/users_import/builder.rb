require "csv"

class UsersImport::Builder
  attr_reader :csv

  def initialize(filepath)
    file = File.open(filepath).read
    @csv = CSV.parse(file, headers: true)
  end

  def process
    saved = []
    not_saved = []
    @csv.each do |user|
      email = user["RegisteredUserEmail"].downcase if user["RegisteredUserEmail"].present?
      u = User.where(email: email).first_or_initialize
      if u.new_record? && email.present?
        log "saving: #{email}"

        u.imported = true
        map.each do |csv_h, db_h|
          u.send("#{db_h}=", user[csv_h])
        end
        u = assign_password(u)
        u.agreed_with_privacy_policy = "1"
        u.skip_confirmation!
        if u.save
          u.update_column(:created_at, Date.strptime(user["UserCreationDate"], "%m/%d/%Y")) if user["UserCreationDate"].present?
          saved << u
        else
          log "not saved: #{email}: #{u.errors.inspect}"
          not_saved << u
        end
      else
        log "Email already exists: #{email}"
      end
    end
    log "Imported: #{saved.count}; not_saved: #{not_saved.map(&:email)}"
    { saved: saved, not_saved: not_saved }
  end

  private

  def log(msg)
    puts msg unless Rails.env.test?
  end

  def map
    {
      "RegisteredUserTitle" => :title,
      "RegisteredUserCompany" => :company_name,
      "RegisteredUserSurname" => :last_name,
      "RegisteredUserFirstname" => :first_name,
      "RegisteredUserAddressLine1" => :address_line1,
      "RegisteredUserAddressLine2" => :address_line2,
      "RegisteredUserAddressLine3" => :address_line3,
      "RegisteredUserPostcode" => :postcode,
      "RegisteredUserTelephone1" => :phone_number,
      "RegisteredUserTelephone2" => :phone_number2,
      "RegisteredUserMobile" => :mobile_number
    }
  end

  def assign_password(user)
    passw = (0...15).map { (65 + rand(26)).chr }.join
    user.password = passw
    user.password_confirmation = passw
    user
  end
end
