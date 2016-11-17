# README


```
# start elasticsearch
docker run -d -p 9200:9200 elasticsearch

# install app dependencies and start the server
bundle
bundle exec rails s -b localhost

# seed data
curl localhost:3000/seed
```

Open [http://localhost:3000/](http://localhost:3000/) in your browser.
