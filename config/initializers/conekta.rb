Conekta.config do |c|
  c.locale = :es
  c.api_key = ENV.fetch("PRIV_CONEKTA_KEY")
  c.api_version = '2.0.0'
end
