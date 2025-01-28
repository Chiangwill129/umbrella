# Write your soltuion here!


require "dotenv/load"
require "http"
require "json"

pp "Hi"

pp "Where are you located?"

user_location = gets.chomp.gsub(" ", "%20")





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





secure_api = ENV.fetch("PIRATE_WEATHER_KEY")

pirate_weather_url = "https://api.pirateweather.net/forecast/" + secure_api + "/#{latitude},#{longitude}"
pirate_weather_data = HTTP.get(pirate_weather_url)
raw_pirate_weather_data = pirate_weather_data.to_s

parsed_pirate_weather = JSON.parse(raw_pirate_weather_data)

currently = parsed_pirate_weather.fetch("currently") 

temp = currently.fetch("temperature")

pp "The current temperature at #{user_location} is #{temp} F"

hourly_hash = parsed_pirate_weather.fetch("hourly")
hourly_data = hourly_hash.fetch("data")

next_12_hours = hourly_data[1..12]

precip_threshold = 0.1
any_precipitation = false

next_12_hours.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_threshold
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time"))

    seconds_from_now = precip_time - Time.now

    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella in the next 12 hours!"
else
  puts "You probably won't need an umbrella for the next 12 hours."
end
