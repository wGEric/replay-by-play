require 'sinatra'
require 'uri'
require 'net/http'

set :pbp_url, URI.parse(ENV.fetch('PBP_URL'))
pbp_json = JSON.parse(Net::HTTP.get(settings.pbp_url))
set :pbp_json, pbp_json
set :pbp_start_time, Time.parse(pbp_json['scheduled'])
set :start_time, Time.now
set :speed, ENV.fetch('SPEED', 1).to_i

def seconds_since_start
  settings.speed * (Time.now.to_i - settings.start_time.to_i)
end

def get_pbp_at(results, time, object, done)
  if !done[:done]
    if !object.key?("updated") || Time.parse(object["updated"]) <= time
      object.each do |key, value|
        next if done[:done]

        case value
        when Array
          results[key] = []
          value.each_with_index do |v, i|
            next if done[:done]
            results[key][i] = {}
            get_pbp_at(results[key][i], time, v, done)
          end
          results[key].compact
        when Hash
          results[key] = {}
          get_pbp_at(results[key], time, value, done)
        else
          results[key] = value
        end
      end
    elsif object.key?("updated")
      done[:done] = true
    end
  end
end

get '*' do
  results = {}
  pbp_time = settings.pbp_start_time + seconds_since_start
  get_pbp_at(results, pbp_time, settings.pbp_json, { done: false })

  headers({
    "PBP START" => settings.pbp_start_time.to_s,
    "PBP TIME" => pbp_time.to_s,
    "Content-Type" => "application/json"
  })

  body(results.to_json)
end
