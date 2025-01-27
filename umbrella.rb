# Write your soltuion here!


require "dotenv/load"
require "http"
require "json"

pp "Hi"

pp "Where are you located?"

user_location = gets.chomp.gsub(" ", "%20")




secure_api = ENV.fetch("PIRATE_WEATHER_KEY")
map_api = ENV.fetch("GMAPS_KEY")


gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{map_api}"

resp = HTTP.get(gmaps_url)
raw_response =  resp.to_s

parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results")

first_result =  results.at(0)

geo = first_result.fetch("geometry")

location = geo.fetch("location")

longitude = location.fetch("lng")
latitude = location.fetch("lat")

pp longitude
pp latitude



pirate_weather_link = "https://api.pirateweather.net/forecast/" + secure_api + "/41.8887,-87.6355"
