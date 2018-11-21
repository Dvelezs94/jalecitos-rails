json.extract! dispute, :id, :order_id, :replies_id, :status, :created_at, :updated_at
json.url dispute_url(dispute, format: :json)
