# A ruby script that makes a restful call to a fake API and shows its response
require 'net/http'
require 'json'

# Local variables
data = "No response body"
subscriptionId = ""
resourceGroup = ""
serviceName = ""
apiName = ""
schemaId = "graphql"
token = ""

# Load GraphQL schema from local file
schemaContent = File.read("./schema.graphql")

# The URL of the API endpoint
uri = URI("https://management.azure.com/subscriptions/#{subscriptionId}/resourceGroups/#{resourceGroup}/providers/Microsoft.ApiManagement/service/#{serviceName}/apis/#{apiName}/schemas/#{schemaId}?api-version=2022-09-01-preview")

# Create a GET request object
request = Net::HTTP::Put.new(uri)

#Prepare headers
request["Authorization"] = token
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"

# Prepare request body and convert to JSON
request.body = {
    "properties": {
        "contentType": "application/vnd.ms-azure-apim.graphql.schema",
        "document": {
            "value": "#{schemaContent}"
        }
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
puts "****************** ASYNC ********************"
puts
puts "Starting async calls to Azure Resource Manager"
puts
puts "Location: #{response['Location']}"
puts

# The URL of the API endpoint
uri = URI("#{response['Location']}")

counter = 1

while true

    # Create a GET request object
    request = Net::HTTP::Get.new(uri)

    #Prepare headers
    request["Authorization"] = token

    # Send the request and get the response
    response = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: true) do |http|
        http.request(request)
    end
    puts "***************** REQUEST *******************"
    puts
    puts "Status code: #{response.code} #{response.message}"
    puts

    if((response.code == "200") || (response.code == "201") || (counter >= 5))
        break
    end

    counter += 1
    sleep(5)
end

# Parse the response body as JSON
data = JSON.parse(response.body) if (!response.body.empty?)
puts
puts "Data: #{data}"
puts
puts "Stopped async calls to Azure Resource Manager"
puts
puts "******************* END *********************"
puts