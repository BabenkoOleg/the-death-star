require 'oauth'

module Upwork
  module Crawler
    class Api
      API_ENPOINTS = {
        jobs: '/profiles/v2/search/jobs',
        categories: '/profiles/v2/metadata/categories',
        skills: '/profiles/v1/metadata/skills'
      }.freeze

      attr_accessor :consumer_key, :consumer_secret, :access_token, :access_secret
      attr_reader :consumer, :token

      def initialize
        @consumer_key =    ENV['upwork_api_consumer_key']
        @consumer_secret = ENV['upwork_api_consumer_secret']
        @access_token =    ENV['upwork_api_access_token']
        @access_secret =   ENV['upwork_api_access_secret']

        @consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
          site: "https://www.upwork.com/api",
          http_method: :get
        })

        @token = OAuth::AccessToken.new(consumer, access_token, access_secret)
      end

      def fetch(entity, params = {})
        url = get_url_with_params(API_ENPOINTS[entity], params)
        response = @token.get(url)
        JSON.parse(response.body)
      end

      private

      def get_url_with_params(path, params = {})
        query_params = params.collect { |k, v| "#{k}=#{OAuth::Helper::escape(v.to_s)}" }.join("&")
        "#{path}.json?#{query_params}"
      end
    end
  end
end
