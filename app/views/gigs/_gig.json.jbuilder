json.extract! gig, :id, :created_at, :updated_at
json.url gig_url(city_slug(gig.city), gig, format: :json)
