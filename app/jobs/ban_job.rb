class BanJob < ApplicationJob
  queue_as :default

  def perform(report)
    # number of reports needed to create a ban record
    ban_creation_count = 10
    # Get Similar Open reports made
    @reports = Report.where(["reportable_type = ? and reportable_id = ?", report.reportable_type, report.reportable_id]).open.count
    # Create Ban if the treshold has been reached
    if @reports >= ban_creation_count
      Ban.create(baneable: report.reportable)
    end
  end
end
