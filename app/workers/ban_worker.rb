class BanWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform(report_id)
    new_report = Report.find(report_id)
    # number of reports needed to create a ban record
    report_creation_count = 1
    # Get Similar Open reports made
    @open_reports = Report.where(["reportable_type = ? and reportable_id = ? and status = 0", new_report.reportable_type, new_report.reportable_id]) #status = 0 means open
    #try to create a ban
    if @open_reports.length >= report_creation_count
      #search if a ban exist
      ban = Ban.where( baneable: report.reportable, status: "pending")
      if ban.exists? #attach the ban to the report
        new_report.update(ban: ban)
      else #create the ban and attach to all reports
        Ban.create(baneable: report.reportable) do |new_ban|
          @open_reports.each do |r|
            r.ban = new_ban
            r.save
          end
        end
      end



    end
  end
end
