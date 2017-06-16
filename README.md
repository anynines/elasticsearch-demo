# elasticsearch demo app

0. [Install/Run](#Install/run)
1. [Features](#features)
2. [Dependencies](#dependencies)
3. [Architecture Structure and Decisions](#architecturestructureanddecisions)
4. [API Endpoints (Inputs, Outputs)](#apiendpointsinputsoutputs)
5. [Debugging Hints/ Unit Tests](#debugginghintsunittests)
6. [Manifest Examples](#manifestexamples)
7. [Links to external Documentation](#linkstoexternaldocumentation)
8. [TODOs](#todos)
9. [Nice to have](#nicetohave)

## Install/Run
### local
* `docker pull elasticsearch`
* `docker run -d -p 9200:9200 elasticsearch`
* `bundle`
* `bundle exec rails s -b localhost`
* `curl localhost:3000/seed`

### on Cloud Foundry
* `cf push`
* `curl <app-url>/seed`

## Features

* fill with random data (seed)
* show entries based on keyword search

## Dependencies

## Architecture Structure and Decisions

## API Endpoints (Inputs, Outputs)

## Debugging Hints/ Unit Tests

## Manifest Examples

## Links to external Documentation

## TODOs
* refine readme

## Nice to have
