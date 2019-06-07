json.extract! product, :id, :product_name, :price, :product_describe, :buy_link, :img, :created_at, :updated_at
json.url product_url(product, format: :json)
