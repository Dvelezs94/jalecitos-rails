module PackagesHelper
  def package_form_url_helper
    if params[:action] == "edit" || params[:action] == "update"
      update_packages_path
    else
      packages_path
    end
  end
  def unit_options
    [
      ['Cantidad',
        [
          ['Unidad', "unit"],
          ['Pieza', "piece"],
          ['Docena', "dozen"]
        ]
      ],
      ['Distancia',
        [
          ['Centímetro', "centimeter"],
          ['Metro', "meter"],
          ['Kilómetro', "kilometer"],
        ]
      ],
      ['Tiempo',
        [
          ['Segundo', "sec"],
          ['Minuto', "minute"],
          ['Hora', "hour"],
          ['Día', "day"]
        ]
      ],
      ['Área',
        [
          ['Centímetro cuadrado', "square_centimeter"],
          ['Metro cuadrado', "square_meter"]
        ]
      ]
    ]
  end
end
