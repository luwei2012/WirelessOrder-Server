json.array!(@menus) do |menu|
  json.extract! menu, 
  json.url menu_url(menu, format: :json)
end
