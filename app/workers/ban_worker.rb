class BanWorker
  include Sidekiq::Worker

  def perform(report_id)
    report = Report.find(report_id)
    # number of reports needed to create a ban record
    report_creation_count = 20
    # Get Similar Open reports made
    @reports = Report.where(["reportable_type = ? and reportable_id = ?", report.reportable_type, report.reportable_id]).open
    # Create Ban if the treshold has been reached
    if @reports.count >= report_creation_count
      @ban = Ban.create(baneable: report.reportable)
      @reports.each do |r|
        r.ban = @ban
        r.save
      end
    end
  end
end
