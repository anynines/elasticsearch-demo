require 'httparty'
require 'ffaker'

class TweetSearchController < ApplicationController
  def index
    params[:query] = 'bacon'
  end

  def results
    query = params[:query]
    @text_results = HTTParty.get("#{es_url}/twitter/tweet/_search?pretty&size=10", es_default_options.merge({body: {"query":{"match_phrase": {"message": '.*' + query + '.*' }}}.to_json}))
    @name_results = HTTParty.get("#{es_url}/twitter/tweet/_search?pretty&size=10", es_default_options.merge({body: {"query":{"match_phrase": {"user": "#{query}" }}}.to_json}))
  end

  def seed
    begin
      users = ['paddy', 'ohli', 'thomyb', 'svon', 'lana', 'robby', 'stefan', 'sarah', 'jenz', 'nicom']

      users.each do |user|
        10.times do
          HTTParty.post("#{es_url}/twitter/tweet", es_default_options.merge({body: {"user" => "#{user}", "message": "#{FFaker::BaconIpsum.sentence}"}.to_json}))
        end
      end
      flash[:success] = "Seeded Elasticsearch"
    rescue StandardError => error
      Rails.logger.info "failed to seed: #{error}"
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

  def es_url
    credentials['host'].first
  end

  def es_auth
    { username: credentials['username'], password: credentials['password'] }
  end

  def es_default_options
    {basic_auth: es_auth}
  end
end

class SeedData

end
