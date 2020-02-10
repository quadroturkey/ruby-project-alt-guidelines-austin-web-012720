10.times do
    User.find_or_create_by(
        name: Faker::Name.name,
        balance: 1000000.0
    )
end

10.times do
    Game.find_or_create_by(
        home: Faker::Team.name,
        away: Faker::Team.name
    )
end



