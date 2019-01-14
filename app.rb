require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rest-client'

FB_ENDPOINT = "https://graph.facebook.com/v2.6/me/messages?access_token=" + "EAAf9VlE5LSsBAMZBnEDd6kQlnHzhDGE3XHQXHe8ZApLWmeC2JiHxOHk29JwU4AnpXvJHxkRFI1ALx3cZAutrc8ybFfLAbXONRENzgFTIukyZCrSO7LxhtLb09yRGyAZCd6CSHvjMZAPfuEl1CyPD5ZAjMqehga8cxm2AkD8AEMPHbnOuGkstrfB"

get '/' do
  'hello'
end

get '/callback' do
  if params["hub.verify_token"] != 'foobarbaz'
    return 'Error, wrong validation tokenz'
  end
    params["hub.challenge"]
end

# when receiving message
post '/callback' do
  hash = JSON.parse(request.body.read)
  message = hash["entry"][0]["messaging"][0]
  sender = message["sender"]["id"]

  #  add message in text 
text = "Search restaurants by your location and category. Say 'hungry!' "
  endpoint = "https://graph.facebook.com/v2.6/me/messages?access_token=" + "EAAf9VlE5LSsBAMZBnEDd6kQlnHzhDGE3XHQXHe8ZApLWmeC2JiHxOHk29JwU4AnpXvJHxkRFI1ALx3cZAutrc8ybFfLAbXONRENzgFTIukyZCrSO7LxhtLb09yRGyAZCd6CSHvjMZAPfuEl1CyPD5ZAjMqehga8cxm2AkD8AEMPHbnOuGkstrfB"
  content = {
    recipient: {id: sender},
    message: {text: text}
  }
  request_body = content.to_json # convert to json

  #reply by POST
  RestClient.post endpoint, request_body, content_type: :json, accept: :json
  status 201
  body ''
end
