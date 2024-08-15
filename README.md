# Laravel Dockerized Project

This project is a Laravel application configured to run in a Dockerized environment. The setup includes Nginx, MySQL, and PHP, managed via Docker Compose.

## Prerequisites

Ensure you have the following installed on your local machine:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)

## Setup Instructions

Follow the steps below to set up and run the project.

### Step 1: Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/your-laravel-project.git
cd your-laravel-project
```
### Step 2: Build and Run the Docker Containers
Use the provided `Makefile` to automate the setup process.

Run the following command to build and start the Docker containers, install dependencies, set permissions, copy the environment file, and generate the application key:

```bash
make setup
```
This command runs the following steps automatically:

#### 1. Build the Docker containers:
Builds the Docker image for the Laravel application.

#### 2. Start the containers:
Starts the Docker containers in detached mode.

#### 3. Install/Update Composer dependencies:
Installs or updates the dependencies specified in composer.json.

#### 4. Set file permissions:
Adjusts the permissions for the storage directory to ensure Laravel can write to it.

#### 5. Copy the .env file:
Copies the .env.example to .env.

#### 5. Generate the application key:
Generates the Laravel application key.

### Step 3: Access the Application
Once the setup is complete, you can access the Laravel application in your browser at:

```bash
http://localhost
```
### Step 4: Stopping the Containers
To stop the Docker containers, run:

```bash
make stop
```
### Additional Makefile Commands
The `Makefile` also includes the following commands:

* `make build`: Builds the Docker images.
* `make composer-update`: Runs composer update inside the Docker container.
* `make composer-install`: Runs composer install inside the Docker container.
* `make permission`: Sets the permissions for the storage directory.
* `make up`: Starts the Docker containers in detached mode.
* `make stop`: Stops the Docker containers.
* `make generate-key`: Generates a new application key for Laravel.
* `make copy-env`: Copies .env.example to .env.

### Troubleshooting
If you encounter any issues during setup or while running the project, try the following:

* Ensure Docker and Docker Compose are installed and running.
* Check for any container-specific issues by running `docker logs <container_name>`.
* If file permission issues occur, re-run `make permission`.

### Summary
This `README.md` file provides clear and concise instructions on how to set up and run this Dockerized Laravel project using the `Makefile`. It covers all the necessary steps and includes additional commands for managing the project. Adjust the URLs, paths, and commands as needed to fit your specific project setup.

