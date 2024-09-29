# Simmer

Simmer is a system designed to run entirely locally without exfiltrating any data outside of the running environment. When dealing with sensitive and classified data we may want to use advanced toolkits to process information locally. There should be no requirement for an internet connection to use the software and fetch any assets. The intent is to hold and process data from scans and logs using rails for the application layer, postgres for storage, minio for simulated s3 in a way that makes data easily identifiable, trackable, taggable, and searchable.

Things you may want to cover:

* Architecture

The Simmer system is designed to be run locally using Docker Compose. The system consists of the following components:

- Rails application: The application layer of Simmer is built using Ruby on Rails. It handles the business logic and provides the API endpoints for data processing.

- Postgres database: Simmer uses PostgreSQL as the database for storing data from scans and logs. It provides a reliable and scalable storage solution.

- Elastisearch: Simmer utilizes Elasticsearch to provide advanced search features. 

- Redis: Simmer uses Redis for user sessions and caching.

The Docker Compose configuration file (`docker-compose.yml`) defines the services and their dependencies. It ensures that all the required components are set up and connected properly.

To run the Simmer system locally in development mode, follow these steps:

1. Install Docker and Docker Compose on your local machine.

2. Clone the Simmer repository.

3. Navigate to the root directory of the project.
4. Create an `.env.config.dev` file in the root directory of the project. This file will contain the environment variables required for the Simmer system to run locally. You can use the `.env.example` file as a template.

  ```bash
  cp .env.example .env.config.dev
  ```

  Open the `.env.config.dev` file in a text editor and update the values of the environment variables according to your local setup.

  Note: Make sure to keep this file private and do not commit it to version control.
5. Run ./setup_ssl.sh to create the self-signed ssl certs for development. 
6. Add the following to your /etc/hosts file 
  ```bash
    127.0.0.1       sim.local
  ```
7. In OSX, add the cert to your keychain with
  ```bash
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain config/ssl/sim.local.crt
  ```
  On Windows, open an Administrator Prompt and add the following from your project root path
  ```bash
  certutil -addstore "Root" "config/ssl/sim.local.crt"
  ```

8. Run the following command to start the system:

  ```bash
  yarn install
  docker-compose up
  ```

  This will build and start all the necessary containers defined in the `docker-compose.yml` file.

9. Access the Simmer application by opening a web browser and navigating to `https://localhost:3000`.

  From here, you can interact with the application, process data, and perform various operations. With a default Kali VM on MacOS M1 with VMWare Fusion, it's possible to connect to the docker rails server and upload data over the computer's network, but you'll need to bind rails port 3000 to 0.0.0.0 instead of 127.0.0.1. 

* Ruby version


* System dependencies

* Configuration

* Database creation
7. Run the following command to create the database:

  ```bash
  docker-compose run web rails db:create
  ```

  This will create the necessary database for the Simmer system.

8. Run the following command to run the database migrations:

  ```bash
  docker-compose run web rails db:migrate
  ```

  This will apply any pending database migrations and update the database schema.

9. Finally, run the following command to seed the database with initial data (if applicable):

  ```bash
  docker-compose run web rails db:seed
  ```

  This will populate the database with any predefined data.

Now you have successfully set up the database for the Simmer system. You can proceed with running the test suite, deploying the application, or any other necessary steps.

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Development

During development, you may need to rebuild the JavaScript assets and watch the code for changes to compile tailwind classes into application.css. Follow these steps:

1. Make sure you have Node.js and Yarn installed on your local machine.

2. Run the following command to rebuild and install the JavaScript assets into the asset pipeline:

  ```bash
  npm run build && rails assets:precompile
  ```

3. Run the following command to watch the files for changes in CSS definitions or tailwind class usage:

  ```bash
  yarn tailwindcss --postcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --watch
  ```
Note that tailwind only includes classes referenced in the code unless specifically included in the config.
  

Now you can make changes to the JavaScript and CSS files during development and see the updates reflected in the Simmer application.

* API Access
You can create a service token for api access and make requests to api paths using 
  ```
  curl -H "Authorization: Bearer <TOKEN>" https://localhost:3000/api/v1/data_sets/
  ```
  You'll need to add -k before -H to ignore ssl certs unless you've installed a proper one. 
  
  Here's an example of how to add gitleaks json output to a new or existing data set. Data sets are looked up by name. Repeated requests are idempotent; duplicates will not be added to the same data set. 
  ```
  curl -k -X POST https://localhost:3000/api/v1/data_sets \
  -F "gitleaks_json=@test_1_event_in_array.json" \
  -F "data_set[name]=test_1_event_in_array" \
  -F "client_id=<REPLACE_WITH_CLIENT_UUID>" \
  -H "Authorization: Bearer <REPLACE_WITH_API_TOKEN>"
  ```

* Deployment instructions

* TODO

- Add tests

- Add response playbook links to notion docs/copy local 