require 'httparty'
require 'ffaker'

class TweetSearchController < ApplicationController
  def index
    params[:query] = 'bacon'
  end

  def results
    query = params[:query]
    @text_results = HTTParty.get("#{es_url}/twitter/tweet/_search?pretty&size=5", es_default_options.merge({body: {"query":{"match_phrase": {"message": '.*' + query + '.*' }}}.to_json}))
    @name_results = HTTParty.get("#{es_url}/twitter/tweet/_search?pretty&size=5", es_default_options.merge({body: {"query":{"match_phrase": {"user": "#{query}" }}}.to_json}))
  end

  def seed
    begin
      users = ['paddy', 'ohli', 'thomyb', 'svon', 'lana', 'robby', 'stefan', 'sarah', 'jenz', 'nicom']

      users.each do |user|
        10.times do
          result = HTTParty.post("#{es_url}/twitter/tweet", es_default_options.merge({body: {"user" => "#{user}", "message": "#{FFaker::BaconIpsum.sentence}"}.to_json}))
          Rails.logger.info "result: #{result.inspect}"
        end
      end
      flash[:success] = "Seeded Elasticsearch"
      Rails.logger.info "Seeded Elasticsearch"
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
        vcap_services = JSON.parse(ENV['VCAP_SERVICES'])
        cred = vcap_services[vcap_services.keys.first].first['credentials']

        # store ca cert file for later use if present in VCAP_SERVICES
        if cred['cacrt']
          File.write(ca_cert_location, cred['cacrt'])
        end

        cred
      end
    end
  end

  # returns nil if not present
  def ca_cert_string
   @ca_cert_string ||= begin
     vcap_services[vcap_services.keys.first].first['credentials']['cacrt']
   end
  end

  def es_url
    credentials['host'].first
  end

  def es_auth
    { username: credentials['username'], password: credentials['password'] }
  end

  def es_default_options
    @es_default_options ||= begin
      {basic_auth: es_auth, ssl_ca_file: ca_cert_location, :headers => {'Content-Type' => 'application/json'}}
    end
  end

  # Returns ca cert location if cert str is present, otherwise nil
  def ca_cert_location
    @ca_cert_location ||= begin
      if cf?
        File.join(tmp_dir, 'ca.crt')
      else
        nil
      end
    end
  end

  def cf?
    ENV['VCAP_SERVICES'].present?
  end

  def vcap_services
    return {} if not cf?

    JSON.parse(ENV['VCAP_SERVICES'])
  end

  def tmp_dir
    ENV["TMPDIR"] || "/tmp"
  end
end
