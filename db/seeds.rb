require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

categories_names = [
    'Informatica',
    'Web',
    'Applicazioni Mobile',
    'Microcontrollori',
    'Meccanica',
    'Automotive',
    'Meccatronica',
    'Elettronica',
    'Hardware',
    'Automazione',
    'Bot',
    'Robotica',
    'Droni',
    'Telecomunicazioni',
    'Strutture',
    'Ambiente',
    'Urbanistica',
    'Idraulica',
    'Energie Alternative',
]
categories = []
categories_names.each {|name| categories.push(Category.create({name: name}))}

courses_names = [
    'Ingegneria Elettronica e Informatica',
    'Ingegneria Meccanica LT',
    'Ingegneria Civile e Ambientale',
    'Ingegneria Elettronica e delle Telecomunicazioni',
    "Ingegneria Informatica e dell' Automazione",
    'Ingegneria Civile',
    'Ingegneria Meccanica LM'
]
courses = []
courses_names.each {|name| courses.push(Course.create({name: name}))}

statuses = [
    'Aperto',
    'Chiuso',
    'Terminato'
]
statuses.each {|name| ProjectStatus.create({name: name})}

20.times do
  firstname = Faker::Name.unique.first_name
  lastname = Faker::Name.unique.last_name
  user = User.new(
      {
          firstname: firstname,
          lastname: lastname,
          email: "#{firstname}.#{lastname}@student.unife.it".downcase!,
          password_digest: "#{BCrypt::Password.create('password')}",
          bio: Faker::Lorem.paragraph,
          birthday: Faker::Date.birthday(19, 30),
          phone: 1234567890,
          profile_picture_path: '/path/to/pic.png',
          course_id: Faker::Number.between(1, 7)
      }
  )
  user.categories << categories.sample(3)
  user.save!
end

5.times do |i|
  project = Project.new(
      {
          project_status_id: 1,
          title: Faker::Space.unique.galaxy,
          description: Faker::Lorem.paragraph
      }
  )
  project.categories << categories.sample
  project.save!
end

10.times do |i|
  project_user = ProjectsUser.create({project_id: (i % 5) + 1, user_id: i + 6, admin: false})
  if project_user.id % 2 == 0
    project_user.admin = true
  end
  project_user.save!
end

25.times do
  news = News.create(
      {
          title: Faker::OnePiece.unique.quote,
          description: Faker::SiliconValley.quote
      }
  )
  if news.id % 2 == 0
    news.courses << courses.sample
  end
end


5.times do |i|
  StudyGroup.create(
      {
          title: Faker::StarWars.unique.planet,
          description: Faker::StarWars.unique.quote,
          course_id: Faker::Number.between(1, 7),
          user_id: i + 11
      }
  )
end
