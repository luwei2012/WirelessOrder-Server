json.array!(@dishes) do |dish|
  json.extract! dish, 
  json.url dish_url(dish, format: :json)
end
