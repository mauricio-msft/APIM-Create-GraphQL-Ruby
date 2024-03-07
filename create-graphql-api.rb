require 'net/http'
require 'json'

# Local variables
data = "No response body"
subscriptionId = ""
resourceGroup = ""
serviceName = ""
apiName = ""
displayName = ""
path = ""
type = "graphql"
token = ""
serviceUrl = "" # GraphQL backend url

# The URL of the API endpoint
uri = URI("https://management.azure.com/subscriptions/#{subscriptionId}/resourceGroups/#{resourceGroup}/providers/Microsoft.ApiManagement/service/#{serviceName}/apis/#{apiName}?api-version=2023-03-01-preview")

# Create a PUT request object
request = Net::HTTP::Put.new(uri)

#Prepare headers
request["Authorization"] = token
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"

# Prepare request body and convert to JSON
request.body = {
    "id": "/subscriptions/#{subscriptionId}/resourceGroups/#{resourceGroup}/providers/Microsoft.ApiManagement/service/#{serviceName}/apis/#{apiName}",
    "name": "#{displayName}",
    "properties": {
        "displayName": "#{displayName}",
        "serviceUrl": "#{serviceUrl}",
        "protocols": [
            "https"
        ],
        "description": "",
        "path": "#{path}",
        "type": "#{type}"
    }
}.to_json

# Send the request and get the response
response = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: true) do |http|
  http.request(request)
end

# Parse the response body as JSON
data = JSON.parse(response.body) if (!response.body.empty?)
 
# Print the response status code and data
puts
puts "***************** REQUEST *******************"
puts
puts "Status code: #{response.code} #{response.message}"
puts
puts "**************** RESPONSE *******************"
puts
puts "Response: #{data}"
puts
puts "******************* END *********************"
puts
