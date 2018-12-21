module BansHelper
  def ban_name_helper(ban)
    if ban.baneable_type == "Gig"
      return link_to "(#{ban.status}) Jale: Voy a #{ban.baneable.name}", user_gig_path(ban.baneable.user, ban.baneable)
    elsif ban.baneable_type == "Request"
      return link_to "(#{ban.status}) Pedido: Busco a alguien #{ban.baneable.name}", request_path(ban.baneable)
    elsif ban.baneable_type == "User"
      return link_to "(#{ban.status}) Usuario: #{ban.baneable.alias}", user_path(ban.baneable)
    end
  end
end
