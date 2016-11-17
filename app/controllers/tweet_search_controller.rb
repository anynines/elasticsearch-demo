require 'httparty'
require 'ffaker'

class TweetSearchController < ApplicationController
  def index
  end

  def results
    query = params[:query]
    @text_results = HTTParty.get( "#{elasticsearch_url}/twitter/tweet/_search?pretty", basic_auth: elasticsearch_auth, body: {"query":{"match_phrase": {"message": '.*' + query + '.*' }}}.to_json)
    @name_results = HTTParty.get( "#{elasticsearch_url}/twitter/tweet/_search?pretty", basic_auth: elasticsearch_auth, body: {"query":{"match_phrase": {"user": "#{query}" }}}.to_json)
  end

  def seed
    begin
      elastic_url = credentials['host']

      users = ['paddy', 'ohli', 'thomyb', 'svon', 'lana', 'robby', 'stefan', 'sarah', 'jenz', 'nicom']

      users.each do |user|
        10.times do
          HTTParty.post( "#{elastic_url.first}/twitter/tweet", basic_auth: elasticsearch_auth, body: {"user" => "#{user}", "message": "#{FFaker::BaconIpsum.sentence}"}.to_json)

        end
      end
      flash[:success] = "Seeded Elasticsearch"
    rescue
      Rails.logger.info 'failed to seed'
    end
    redirect_to root_path
  end

  private

  def credentials
    @credentials ||= begin
      if ENV['VCAP_SERVICES'].blank?
        {
          'host' => ["http://localhost:9200"]
        }
      else
        JSON.parse(ENV['VCAP_SERVICES'])['a9s-elasticsearch'].first['credentials']
      end
    end
  end

  def elasticsearch_url
    credentials['host'].first
  end

  def elasticsearch_auth
    { username: credentials['username'], password: credentials['password'] }
  end
end
