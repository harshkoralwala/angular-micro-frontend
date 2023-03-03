# Project360


## Setup

Run the following commands to install all dependencies...

```shell
cd shared && npm i && cd .. && \
cd shared-backend && npm i && cd .. && \
cd server && npm i && cd .. && \
cd client && npm i && cd .. && \
cd test360-runner && npm i && cd .. && \
cp .env.sample.json .env.json
```

There are two options for secret handling during development.
1. Use local secrets for application secrets

   You can use local secrets for application secrets (e.g. connection to the database). In order to use that, run the following command:
   ```shell
   # in server
   cp secrets.sample.json secrets.json
   ```
   Application secrets will then be fetched from that file.
   
2. Use remote secrets (from secret manager) for application secrets

   You can use secrets from secret manager. In order to do that, you need to get a service account in GCP having access to secret manager.
   Afterwards, you can download its key and maintain the path in `.env.json`.
   To tell the application to use this key, you need to set the environment variable `USE_SECRET_MANAGER` to 1: 
   
   `export USE_SECRET_MANAGER=1`

   The application will then fetch all application secrets from secret manager using the environment specified in .env.json as prefix.


The application requires a running database. To start a postgres & a redis database locally, you can run:
```shell
docker-compose up
```
This will start a local postgres database on port 54321. (the sample config is pre-configured accordingly)
This will start a local redis database in port 6379. 

## Development

### General

You need node and npm installed

You need the Nest CLI globally installed: 
```sudo npm install -g @nestjs/cli```

The application consists of 5 parts:
- shared (contains code that is shared between server, client & test360-runner)
- shared-backend (contains code that is shared between server and test360-runner)
- client (frontend, Angular)
- server (backend, NestJS)
- test360-runner (runner, NestJS)

To start developing, first start the watcher for the `shared` part (inside the shared directory):
```npm run watch```
Keep it running.

Afterwards, start the watcher for the Angular application (inside the client directory):
```npm run start```
Keep it running.

Start the watcher for the `shared-backend` part (inside the shared-backend directory):
```npm run watch```
Keep it running.

Start the watcher for the server application (inside the server directory):
```npm run start:dev```
Keep it running.

Start the watcher for the test360-runner application (inside the test360-runner directory):
```npm run start:dev```
Keep it running.

Changes to the code will automatically restart the affected component.


### Database

The database will be initalized automatically. Migrations will run automatically as well. To generate new migrations (after changing entities or adding new entities), check out the README in `server/src/migrations/README.md`.

### Tests

#### Backend
For backend tests, you can use `server/src/model/project-management/project/project.service.spec.ts` as an example. Database repositories are mocked using the `repositoryMockFactory` defined in `server/src/test/helpers.ts`.

#### Frontend
For frontend tests, you can use `client/src/app/authentication/login/login.component.spec.ts` as an example.


## CI/CD

Gitlab CI is used to build the Docker image.

The `.gitlab-ci.yml` defines global pipeline parameters and includes pipeline definitions from the `cicd` directory.
Currently, there are 5 files:

### templates.gitlab-ci.yml
Reusable jobs are defined here.

### common.gitlab-ci.yml
Jobs that should run in any workflow are defined here.

### merge-requests.gitlab-ci.yml
Jobs that should run in a MR are defined here.

### branch-main.gitlab-ci.yml
Jobs that should run in on the main branch are defined here.

### tags.gitlab-ci.yml
Jobs that should run on tags are defined here.

Every commit on the main branch will trigger a build with a deployment to the staging environment.
Every tag will trigger a build with a deployment to the production environment.

## Backend API
The backend provides an API. The documentation for the backend is availale under http://localhost:3000/swagger
The documentation is also available as json in the swagger-spec.json file