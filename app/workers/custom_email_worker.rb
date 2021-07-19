class CustomEmailWorker
  include Cloudtasker::Worker

  def perform(request)
    puts "processing email #{request}"
    CustomEmailForm.new(JSON.parse(request).with_indifferent_access).send!
  end
end
