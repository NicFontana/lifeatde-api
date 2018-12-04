
# LifeAtDE - API
An academic Ruby on Rails (API only) application built by students for the students of the Ferrara's Department of Engineering.
Since it is an API only application, we've also build the client counterpart in [React](https://github.com/facebook/react) which you can find [here](https://github.com/xBlue0/lifeatde-app).

:books: *__Disclaimer__* :books:
The project was born from one of our ideas and aims to fulfill the requests of the Concurrent Programming Laboratory course, i.e. it is not a platform associated with the University of Ferrara.

## Demo
A demo is available at [https://www.lifeatde.herokuapp.com](https://www.lifeatde.herokuapp.com)

Login available with:
* Username: ``` john.doe@student.unife.it```
* Password: ```password```

## Goal
Build a mobile first Web Application that allows, quickly and intuitively, to:
* Look for other students to collaborate with to carry out extra-curricular projects encouraging ideas and knowledge sharing
* Sell and exchange teaching materials
* Create study groups
* Stay informed about the news of the Department

## Under the hood
The endpoints are **authenticated** using the [JWT](https://jwt.io) standard thanks to the [ruby-jwt](https://github.com/jwt/ruby-jwt) gem. They provide data that follow the [JSON:API](https://jsonapi.org) specification as the **serialization** is done by the [fast_jsonapi](https://github.com/Netflix/fast_jsonapi) gem.
Of course every result is **paginated** and we decided to entrust this task to the [pagy](https://github.com/ddnexus/pagy) gem.

## Install and Run
**_Requirements:_**
* Ruby 2.5.1
* Bundler
* MySQL >= 5.5

Clone or download this repository, open a new terminal inside the project directory, then:
1. ```bundle install```
2. ```cp config/database.yml.example config/database.yml```
3. Open the ```config/database.yml``` file and set the ```database``` ```username``` and ```password``` variables according to your needs
4. Start your installed MySQL
5. ```bin/rake db:create```
6. ```bin/rake db:migrate```
7. ```bin/rake db:seed```
8. ```rm config/credentials.yml.enc```
9. ```EDITOR=nano bin/rails credentials:edit``` this command will prompt up a nano editor with some config data; you just need to press ```CTRL+X``` to save and ```ENTER``` key to exit the editor.
10. ```bundle exec rails s -p 3001```
11. Follow the client side instructions written [here](https://github.com/xBlue0/lifeatde-app)

Login available with:
* Username: ``` john.doe@student.unife.it```
* Password: ```password```

## Team :rocket:
* [Niccolò Fontana](https://github.com/NicFontana)
* [Federico Frigo](https://github.com/xBlue0)
* [Giovanni Fiorini](https://github.com/GiovanniFiorini)
