# PhoenixBloc

To start your Phoenix server:

  * Build Docker images with `docker-compose build`
  * Install dependencies with `docker-compose run --rm web mix deps.get`
  * Install Node.js dependencies with `docker-compose run --rm web sh -c "cd assets && npm install"`
  * Start Phoenix endpoint with `docker-compose up`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## To-do

  * Implement proper OT
  * Save the latest bloc version
