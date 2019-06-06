module FilterMarketingCampaign
  def get_users(filters={})
    result = User.active
    # filters here
    result = result.where(city: [State.find(filters[:state_id]).cities]) if filters[:state_id].present?
    # result = result.where() if filters[:has_gigs].true?
    # end filters
    return result
  end
end
