# README
Test task

Ruby  2.4.1, Rails 5.1.3
### System dependencies
* postgressql 5.4 or higher

* Configuration
Clone this repo, run bundle.
Rename database.yml.example to database.yml and set his variables.
Create secret.yml

* Database creation
run rake db:setup
For parallel testing create test_env databases
Create additional database(s)
rake parallel:create
Copy development schema (repeat after migrations)
rake parallel:prepare
Setup environment from scratch (create db and loads schema, useful for CI)
rake parallel:setup

* Database initialization
You can add users`s seed data 
run rake db:seed:users_seed

* How to run the test suite
Run rspec spec/ or rake -t
For parallel testing run
rake parallel:spec  

* Deployment instructions

* ...
