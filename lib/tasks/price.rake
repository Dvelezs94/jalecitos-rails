task :price => [:environment] do
  models = [Package, Offer]

  models.each do |model|
    model.where.not(price: nil).each do |mod|
      mod_price = mod.price * 0.9 + 0.1
      mod.update( price: mod_price )
    end
  end
  puts "finished updating prices"
end
