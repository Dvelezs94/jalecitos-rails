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
          ['Pieza', "piece"],
          ['Docena', "dozen"],
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
      ]
    ]
  end
end
