## README
This app is a warehouse booking app. It is built with a Ruby on Rails API and a React frontend. 📦🚚

Features Summary:
- users can search for available slots and book an available one
- users can view slots that have already been booked on the calendar
- slots can't overlap with existing ones
- slots start at multiple of 15 minutes i.e 9:15, 10:00
- minimum duration for a slot is 10 minutes 

#### Requirements
To run the app successfully, the following must be installed in your local environment: 
```
- Node JS
- Ruby
- Ruby on Rails
- SQLite
- Git
```

#### Setup
Clone the repo by running: 
`git clone git@github.com:briankabiro/warehouse-booking-app.git`

#### Backend setup
1. From the terminal, navigate to the backend folder: `cd warehouse-booking-app/backend`
2. Install the dependencies by running: `bundle install`
3. Setup the database: `rails db:setup`
4. Run the migrations: `rails db:migrate`
6. Start the Rails application on **port 8080**:
`rails s -p 8080`

**Backend tests**
- Run the tests for the Rails API: 
`rspec -f d`
- The controller tests are in the `spec/requests` folder
- Model tests are in the `spec/models` folder

**Rubocop**
- In the main backend directory, run the linter for the backend code:
`rubocop`

#### Frontend setup
1. Navigate to the frontend folder
`cd frontend`
2. Install dependencies
`yarn install`
3. Start the application:
`yarn start`
4. Visit `localhost:8081` on the browser to see the React app
5. You are now ready to book some slots! Enjoy.

#### Screenshots
![image](https://github.com/briankabiro/warehouse-booking-app/assets/22860561/94a64283-35aa-41e0-8521-eaa397d339b6)
![image](https://github.com/briankabiro/warehouse-booking-app/assets/22860561/fb0d3f0c-4749-4afc-ad00-40790c3c0f9f)
![image](https://github.com/briankabiro/warehouse-booking-app/assets/22860561/79c06d83-5668-46b6-ae9d-199b996dc07d)

#### Technologies Used
- Ant Design
- Full Calendar
- SQLite
