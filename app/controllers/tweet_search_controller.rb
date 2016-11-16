require 'httparty'
require 'ffaker'
class TweetSearchController < ApplicationController
  def index
  end

  def results

    elastic_url = credentials['host']
    auth = {username: credentials['username'], password: credentials['password'] }
    query = params[:query]
    @text_results = HTTParty.get( "http://#{elastic_url.first}/twitter/tweet/_search?pretty", basic_auth: auth, body: {"query":{"match_phrase": {"message": '.*' + query + '.*' }}}.to_json)
    @name_results = HTTParty.get( "http://#{elastic_url.first}/twitter/tweet/_search?pretty", basic_auth: auth, body: {"query":{"match_phrase": {"user": "#{query}" }}}.to_json)

  end

  def seed
    begin
      elastic_url = credentials['host']

      auth = {username: credentials['username'], password: credentials['password'] }
      users = ['paddy', 'ohli', 'thomyb', 'svon', 'lana', 'robby', 'stefan', 'sarah', 'jenz', 'nicom']

      users.each do |user|
        10.times do
          HTTParty.post( "http://#{elastic_url.first}/twitter/tweet", basic_auth: auth, body: {"user" => "#{user}", "message": "#{FFaker::BaconIpsum.sentence}"}.to_json)

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
    JSON.parse(ENV['VCAP_SERVICES'])['a9s-elasticsearch'].first['credentials']
  end
end
