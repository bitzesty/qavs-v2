shared_examples "date_time_for" do |field|
  it "returns date" do
    subject.public_send("#{field}=", Time.zone.local(2012, 9, 6, 1, 30))
    expect(subject.public_send("#{field}_date")).to eq(Date.civil(2012, 9, 6))
  end

  it "returns seconds of beginning of day" do
    subject.public_send("#{field}=", Time.zone.local(2012, 9, 6, 1, 30))
    expect(subject.public_send("formatted_#{field}_time")).to eq("01:30")
    expect(subject.public_send("formatted_#{field}_day")).to eq("06")
    expect(subject.public_send("formatted_#{field}_month")).to eq("09")
    expect(subject.public_send("formatted_#{field}_year")).to eq("2012")
  end

  it "returns Time" do
    subject.public_send "formatted_#{field}_day=", "06"
    subject.public_send "formatted_#{field}_month=", "09"
    subject.public_send "formatted_#{field}_year=", "2012"
    subject.public_send "formatted_#{field}_time=", "01:30"
    expect(subject.public_send(field)).to eq(Time.zone.local(2012, 9, 6, 1, 30))
  end

  it "resets value" do
    subject.public_send("#{field}=", Time.zone.local(2012, 9, 6, 1, 30))
    subject.public_send("formatted_#{field}_day=", "")
    subject.public_send("formatted_#{field}_month=", "")
    subject.public_send("formatted_#{field}_year=", "")
    subject.public_send("formatted_#{field}_time=", "")
    expect(subject.public_send(field)).to be_nil
  end

  it "updates date" do
    subject.public_send("#{field}=", Time.zone.local(2012, 9, 6, 1, 30))
    subject.public_send("formatted_#{field}_day=", "05")
    subject.public_send("formatted_#{field}_month=", "09")
    subject.public_send("formatted_#{field}_year=", "2012")
    expect(subject.public_send(field)).to eq(Time.zone.local(2012, 9, 5, 1, 30))
  end

  it "updates time twice" do
    subject.public_send("#{field}=", Time.zone.local(2012, 9, 6, 1, 30))
    subject.public_send("formatted_#{field}_day=", "05")
    subject.public_send("formatted_#{field}_month=", "09")
    subject.public_send("formatted_#{field}_year=", "2012")
    subject.public_send "formatted_#{field}_time=", "01:30"
    subject.public_send "formatted_#{field}_time=", "03:30"
    expect(subject.public_send(field)).to eq(Time.zone.local(2012, 9, 5, 3, 30))
  end
end
