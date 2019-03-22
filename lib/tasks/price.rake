task :price => [:environment] do
  Package.where.not(price: nil).each do |pack|
    pack_price = pack.price * 0.9 + 0.1
    pack.update( price: pack_price )
  end
  puts "finished updating prices"
end
