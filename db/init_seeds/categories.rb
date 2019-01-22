#!/bin/env ruby
# encoding: utf-8
module InitCategories
  def self.all
    [
     ["Alimentos", "utensils"],
     ["Arte y Diseño", "paint-brush"],
     ["Asistencia Técnica", "hands-helping"],
     ["Belleza", "magic"],
     ["Comunicación", "broadcast-tower"],
     ["Deportes y Recreación", "futbol"],
     ["Educación", "book"],
     ["Entretenimiento", "tv"],
     ["Eventos", "glass-martini"],
     ["Hogar", "home"],
     ["Legal", "balance-scale"],
     ["Limpieza", "broom"],
     ["Mantenimiento", "cog"],
     ["Mascotas", "paw"],
     ["Manualidades", "cut"],
     ["Multimedia", "film"],
     ["Negocios", "briefcase"],
     ["Reparación", "wrench"],
     ["Salud", "heartbeat"],
     ["Seguridad", "shield-alt"],
     ["Servicios Profesionales", "user-tie"],
     ["Tecnología", "laptop"],
     ["Transporte", "bus"],
     ["Vehículos", "car"],
     ["Otro", "globe-americas"]
    ]
  end
end

InitCategories.all.each do |category|
  Category.create(name: category[0], icon: category[1])
end
