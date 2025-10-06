# Test support: installs WebMock stubs used by Cucumber features.
# Stubs TheMealDB filter and lookup endpoints so feature tests run deterministically
# without making external HTTP requests.
#
# @param format [Symbol] example placeholder for documentation consistency
# @return [void] sets up Before hooks and stubbed HTTP responses
# def to_format(format = :html)
#   # format the support description (example placeholder for YARD)
# end
#
require 'webmock/cucumber'

WebMock.disable_net_connect!(allow_localhost: true)

Before do
  stub_request(:get, /themealdb\.com.*filter\.php/)
    .to_return(
      status: 200,
      body: {
        meals: [
          {
            idMeal: "52772",
            strMeal: "Teriyaki Chicken Casserole",
            strMealThumb: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"
          },
          {
            idMeal: "52773",
            strMeal: "Chicken Rice Soup",
            strMealThumb: "https://www.themealdb.com/images/media/meals/example.jpg"
          }
        ]
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

  stub_request(:get, /themealdb\.com.*lookup\.php/)
    .to_return(
      status: 200,
      body: {
        meals: [
          {
            idMeal: "52772",
            strMeal: "Teriyaki Chicken Casserole",
            strMealThumb: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
            strInstructions: "Cook the chicken...",
            strIngredient1: "chicken",
            strIngredient2: "rice"
          }
        ]
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end
