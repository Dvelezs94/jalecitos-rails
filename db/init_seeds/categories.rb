#!/bin/env ruby
# encoding: utf-8
module InitCategories
  def self.all
    [
     "Alimentos", "Arte y Diseño", "Asistencia Técnica", "Belleza", "Comunicación", "Deportes y Recreación",
     "Educación", "Entretenimiento", "Eventos", "Hogar", "Legal", "Limpieza", "Mantenimiento", "Mascotas", "Manualidades", "Multimedia",
     "Negocios", "Reparación", "Salud", "Seguridad", "Servicios Profesionales", "Tecnología", "Transporte", "Vehículos", "Otro"
    ]
  end
end

InitCategories.all.each do |category|
  Category.create(name: category)
end
