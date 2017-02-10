require 'sinatra'
require 'json'

@@jobs = [{id: 1, name: 'Job 1'},{id: 2, name: 'Job 2'}]

set :protection, :except => [:json_csrf]

before do
  headers 'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => "POST, DELETE"
  content_type :json
end

options '*' do
  halt 200
end

get '/' do
  redirect '/jobs/'
end

get '/jobs/' do
  @@jobs.to_json
end

post '/jobs/' do
  job = {name: params['name']}
  max_id = @@jobs.collect{|job| job[:id]}.max || 0
  job[:id] = max_id + 1

  @@jobs << job

  [ 201, job.to_json ]
end

delete '/jobs/:id' do
  found = @@jobs.find{|job| job[:id] == params[:id].to_i}
  halt 404 unless found

  @@jobs.reject!{|job| job == found}
  halt 204
end
