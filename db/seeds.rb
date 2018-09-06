require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

categories = [
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
categories.each {|name| Category.create({name: name}) }

courses_names = [
		'Ingegneria Elettronica e Informatica',
		'Ingegneria Meccanica LT',
		'Ingegneria Civile e Ambientale',
		'Ingegneria Elettronica e delle Telecomunicazioni',
		"Ingegneria Informatica e dell' Automazione",
		'Ingegneria Civile',
		'Ingegneria Meccanica LM'
]
courses=[]
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
	user = User.create(
			{
					firstname: firstname,
					lastname: lastname,
					email: "#{firstname}.#{lastname}@student.unife.it".downcase!,
					password_digest: "#{BCrypt::Password.create('password')}",
					bio: Faker::Lorem.paragraph,
					birthday: Faker::Date.birthday(19, 30),
					phone: Faker::PhoneNumber.cell_phone,
					profile_picture_path: '/path/to/pic',
					course_id: Faker::Number.between(1, 7)
			}
	)
	3.times do
		user_category = UserCategory.create({user: user, category_id: Faker::Number.between(1, 19)})
	end
end

5.times do |i|
	project = Project.create(
			{
					project_status_id: 1,
					user_id: i + 1,
					title: Faker::Space.unique.galaxy,
					description: Faker::Lorem.paragraph
			}
	)
	ProjectCategory.create({project: project, category_id: Faker::Number.between(1, 19)})
end

5.times do |i|
	ProjectUser.create({project_id: i, user_id: i + 6})
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
