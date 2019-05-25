class BanWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform(report_id)
    new_report = Report.find(report_id)
    # number of reports needed to create a ban record
    create_ban_at = 5
    # Get Similar Open reports made
    @open_reports = Report.where(reportable: new_report.reportable, status: "open")
    #try to create a ban
    if @open_reports.length >= create_ban_at
      #search if a ban exist for that object
      ban = Ban.find_by( baneable: new_report.reportable, status: "banned")
      if ban.present? #attach the ban to the report, this isnt going to be used never, unless at the exact time of ban a report enters
        new_report.update(ban: ban, status: "accepted")
      else #create the ban and attach to all reports
        Ban.create(baneable: new_report.reportable, cause: "system_ban")
      end
    end
  end
end
