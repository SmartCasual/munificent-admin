Rails.application.routes.draw do
  mount Munificent::Admin::Engine => "/"
end
