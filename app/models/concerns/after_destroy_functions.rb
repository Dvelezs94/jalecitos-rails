module AfterDestroyFunctions
  private
  def mark_reports_and_bans
    #is one or another, if there are open reports, it cant be a ban and vice versa
    reports = Report.where(status: "open", reportable: self)
    reports.each do |r|
      r.update!(status: "deleted_resource")
    end

    ban = Ban.find_by(status: "banned", baneable: self)
    ban.update!(status: "deleted_resource") if ban.present?
  end

end
