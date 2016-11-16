Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   get "tweet_search" => "tweet_search#index"
   get "seed" => "tweet_search#seed"
   post "results" => "tweet_search#results"
   post "tweet_search/results" => "tweet_search#results"
   root 'tweet_search#index'
end
