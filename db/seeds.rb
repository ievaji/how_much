# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts ''
puts 'First task:'
puts ''
puts 'Creating one user - YOU!'
puts '...'

ieva = User.new(
  name: 'ieva',
  email: 'ieva@gmail.com',
  password: 'testtest'
)

ieva.save!

puts 'Congrats, you now exist!'
puts ''
puts 'Next task:'
puts ''
puts 'Creating Windows!'
puts '...'

windows = [
  { name: 'January',
    start_date: Date.new(2022, 1, 1),
    end_date: Date.new(2022, 1, 31),
    size: 30,
    budget: 600,
    user_id: 1 },
  { name: 'February',
    start_date: Date.new(2022, 2, 1),
    end_date: Date.new(2022, 2, 28),
    size: 27,
    budget: 600,
    user_id: 1 },
  { name: '2022',
    start_date: Date.new(2022, 1, 1),
    end_date: Date.new(2022, 12, 31),
    size: 365,
    budget: 10_000,
    user_id: 1 }
]

i = 1

windows.each do |window|
  win = Window.new(window)
  win.save!
  puts "Window #{i} created!"
  i += 1
end

puts ''
puts 'Next task:'
puts ''
puts 'Creating Lists!'
puts '...'

lists = [
  { name: 'Groceries',
    budget: 200,
    user_id: 1 },
  { name: 'Take-Away',
    budget: 150,
    user_id: 1 },
  { name: 'Various',
    budget: 100,
    user_id: 1 }
]

i = 1

windows.length.times do
  lists.each do |list|
    li = List.new(list)
    li.window_id = i
    li.save!
  end
  puts "#{lists.length} Lists for Window #{i} created!"
  i += 1
end

puts ''
puts 'Next task:'
puts ''
puts 'Adding items!'
puts '...'

items = [
  { value: 25,
    user_id: 1 },
  { value: 10,
    user_id: 1 },
  { value: 64,
    user_id: 1 }
]

i = 1

List.all.length.times do
  j = 1
  items.each do |item|
    it = Item.new(value: item[:value], user_id: item[:user_id], list_id: i)
    it.save!
    puts "Item #{j} added to List #{i}."
    j += 1
  end
  i += 1
end

puts ''
puts 'THE END'
puts ''
