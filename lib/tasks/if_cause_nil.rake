task :if_cause_nil => [:environment] do
  Report.all.each do |r|
    if r.cause == nil
      r.update(cause: "fraud")
    end
  end
  puts "Todos los reportes sin causa se han actualizado como causa: fraude"
end
