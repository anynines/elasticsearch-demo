# a9s Elasticsearch Demo App

## Install/Run

### Cloud Foundry
* `cf push`
* `cf bs elastic_demo YOUR_INSTANCE_NAME`
* `cf restage elastic_demo`
* `curl <app-url>/seed`

### Local
* `docker pull docker.elastic.co/elasticsearch/elasticsearch:6.8.5`
* `docker run -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.8.5`
* `bundle`
* `bundle exec rails s`
* `curl localhost:3000/seed`
* Open http://localhost:3000 in your browser


## Features

* fill with random data (seed)
* show entries based on keyword search

## TODOs
* refine readme
