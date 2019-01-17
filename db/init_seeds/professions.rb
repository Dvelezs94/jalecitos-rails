#!/bin/env ruby
# encoding: utf-8
module InitProfessions
  def self.all
    [
     "Abogado", "Actor", "Agente de viajes", "Albañil", "Ama de casa", "Arqueólogo", "Arquitecto", "Asesor, Consultor", "Astronauta", "Azafata",
     "Bailarín", "Basurero", "Bibliotecario", "Biólogo", "Bombero", "Cajero", "Camarero, mesero", "Camionero", "Cantante", "Carnicero", "Carpintero",
     "Cartero", "Cazador", "Científico", "Cirujano", "Cocinero", "Conductor de autobús", "Conserje", "Contador", "Cura", "Decorador", "Dentista",
     "Dependiente de una tienda", "Diseñador", "Economista", "Electricista", "Empresario", "Enfermero", "Escritor", "Farmaceútico", "Florista",
     "Fontanero", "Fotógrafo", "Frutero", "Físico", "Granjero, Agricultor", "Ingeniero", "Investigador", "Jardinero", "Joyero", "Juez", "Limpiacristales",
     "Marinero", "Mecánico", "Meteorólogo", "Minero", "Modelo", "Modista", "Monje", "Médico", "Niñera", "Obrero", "Oficinista", "Panadero", "Pastelero, repostero",
     "Payaso", "Peluquero", "Periodista", "Persona de limpieza", "Pescador", "Pintor", "Plomero", "Policía", "Político", "Portero, conserje", "Profesor",
     "Programador", "Psicólogo", "Psiquiatra", "Químico, farmaceútico", "Recepcionista", "Secretario", "Socorrista", "Taxista", "Telefonista",
     "Trabajador social", "Vendedor", "Veterinario", "Vidente","Zapatero", "Deportista"
    ]
  end
end

InitProfessions.all.each do |category|
  Profession.create(name: category)
end
