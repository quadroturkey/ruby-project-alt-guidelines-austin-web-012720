10.times do
  User.find_or_create_by(
    name: Faker::Name.name,
    balance: 1000000.0
  )
end

# 10.times do
#   spread = rand(5)
#   Game.find_or_create_by(
#     home: Faker::Team.name,
#     away: Faker::Team.name,
#     h_spread: spread,
#     a_spread: spread * (-1)
#   )
# end
response = Unirest.get "https://sportspage-feeds.p.rapidapi.com/games",
  headers:{
    "X-RapidAPI-Host" => "sportspage-feeds.p.rapidapi.com",
    "X-RapidAPI-Key" => "1d54e391b9msh2ac664a56fed0d8p1d7913jsn7d463e8a8620"
  }
games = response.body.dig("results")
binding.pry
games.each do |game|
  Game.create(
  home: game.dig("teams", "home", "team"),
  away: game.dig("teams", "away", "team"),
  h_spread: game.dig("odds")[0].dig("spread", "open",  "home"),
  a_spread: game.dig("odds")[0].dig("spread", "open",  "away"),
  start_time: game.dig("schedule", "date")
)
end
