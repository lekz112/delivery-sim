defmodule User.API do
  use HTTPoison.Base
  require Logger
  import Sim

  def get_restaurants(token) do
    Logger.debug("[U] Get restaurants")

    case HTTPoison.get("#{endpoint()}/restaurants", Sim.headers(token)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, response} = Poison.decode(body)
        response
    end
  end

  def get_dishes(token, restaurantId) do
    Logger.debug("[U] Get dishes")

    case HTTPoison.get(
           "#{endpoint()}/restaurants/#{restaurantId}/dishes",
           Sim.headers(token)
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, response} = Poison.decode(body)
        response
    end
  end

  def add_dish_to_basket(token, restaurantId, dishId, quantity) do
    Logger.debug("[U] Add dish to basket")

    input = %{
      "dishId" => dishId,
      "restaurantId" => restaurantId,
      "quantity" => quantity,
      "forceNewBasket" => true
    }

    case HTTPoison.post(
           "#{endpoint()}/basket/addItem",
           Sim.json(input),
           Sim.headers(token)
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, response} = Poison.decode(body)
        response
    end
  end

  def remove_dish_from_basket(token, restaurantId, dishId, quantity) do
    Logger.debug("[U] Remove dish from basket")

    input = %{
      "dishId" => dishId,
      "restaurantId" => restaurantId,
      "quantity" => quantity
    }

    HTTPoison.post(
      "#{endpoint()}/basket/removeItem",
      Sim.json(input),
      Sim.headers(token)
    )
  end

  def get_basket(token) do
    Logger.debug("[U] Get basket")

    case HTTPoison.get("#{endpoint()}/basket", Sim.headers(token)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, response} = Poison.decode(body)
        response

      {:ok, %HTTPoison.Response{status_code: 204}} ->
        %{}
    end
  end

  def checkout(token) do
    Logger.debug("[U] Checkout")

    case HTTPoison.post("#{endpoint()}/basket/checkout", [], Sim.headers(token)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, response} = Poison.decode(body)
        response
    end
  end

  def set_address(token) do
    {lat, lon} = Sim.random_location()

    input = %{
      "location" => %{
        "latitude" => lat,
        "longitude" => lon
      },
      "address" => "fake",
      "city" => "fake",
      "country" => "fake"
    }

    HTTPoison.post!(
      "#{endpoint()}/profile/address",
      Sim.json(input),
      Sim.headers(token)
    )
  end

  def set_payment_method(token, payment_method_id) do
    input = %{
      "paymentMethodId" => payment_method_id
    }

    HTTPoison.post!(
      "#{endpoint()}/profile/payment_method",
      Sim.json(input),
      Sim.headers(token)
    )
  end
end
