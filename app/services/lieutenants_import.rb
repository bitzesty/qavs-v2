require 'net/http'

class LieutenantsImport
  attr_reader :path

  def initialize(path)
    @path = path

    @logs = {
      warn: [],
      error: []
    }
  end

  def run!
    log("Start import")

    # "oid"
    # "email"
    # "roles"
    # "encrypted_password"
    # "ceremonial_county"
    # "subcommittee"

    CSV.foreach(Rails.root.join(path), headers: true) do |row|
      oid = row["oid"]
      log("Importing #{oid}")

      if Lieutenant.find_by_oid(oid)
        log("Skipping #{oid}, already imported")
        next
      end

      Lieutenant.transaction do
        email = prepare_value(row["email"])

        unless email.present?
          log("Skipping #{oid}, no email", :error)
          next
        end

        u = Lieutenant.new
        u.email = email
        u.oid = oid
        u.first_name = "Imported"
        u.last_name = "Imported"

        u.password = SecureRandom.hex(20)
        u.role = "advanced"
        u.confirmed_at = Time.zone.now

        county = CeremonialCounty.where("LOWER(name) = LOWER(?)", row["ceremonial_county"]).first

        unless county
          if row["ceremonial_county"] == "The City of Londonderry"
            county = CeremonialCounty.where(name: "The County Borough of Londonderry").first
          else
            log("Skipping #{oid}, no county found: `#{row["ceremonial_county"]}`", :error)
            next
          end
        end

        u.ceremonial_county = county
        u.save!
      end
    end

    log("Finished")

    log("Stats:")

    @logs.each do |k, v|
      v.each do |err|
        Rails.logger.send(k, err)
      end
    end

    nil
  end

  private

  def prepare_value(value)
    value.to_s.strip.gsub(/[\u200B-\u200D\uFEFF]/, '')
  end

  def log(str, kind = :info)
    case kind
    when :error
      @logs[:error] += [str]
    when :warn
      @logs[:warn] += [str]
    end

    Rails.logger.send(kind, str)
  end

  # Splits name into First name and last name
  # Where it's needed
  def split_name(str)
    splat = str.split(" ")

    first_name = splat[0].presence || "-"
    last_name = splat[1..-1].join(" ").presence || "-"

    [first_name, last_name]
  end
end
