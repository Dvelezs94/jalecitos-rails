task :cause_to_int => [:environment] do
  conv = {
    "Uso de palabras ofensivas" => "offensive",
     "Contenido Sexual" => "sexual",
     "Violencia" => "violence",
     "Spam" =>"spam",
     "Engaño o fraude" => "fraud",
     "Otro" => "other",
  }
  Report.all.each do |r|
    r.update(cause: conv[r.cause_str])
  end
  ActiveRecord::Migration.remove_column :reports, :cause_str
  puts "Se han terminado de transferir los datos de la columna cause_str to cause (entero) y se ha eliminado la columna cause_str"
end
