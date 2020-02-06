require 'uri'
require 'net/http'
require 'openssl'
require 'base64'
require 'time'

#  constants
APIKEY = 'your-provided-api-key'
SECRET_KEY = 'your-provided-secret-key'
STAGING_HOST = 'https://apix.staging.arcusapi.com'

timestamp = Time.now.utc.httpdate

# checksum generation process
content_type = 'application/json'
content_md5 = Digest::MD5.base64digest('')
endpoint = '/account'
timestamp = timestamp

checksum_string = "#{content_type},#{content_md5},#{endpoint},#{timestamp}"

hmac = OpenSSL::HMAC.digest('sha1', SECRET_KEY, checksum_string)
generated_checksum = Base64.encode64(hmac).strip

#  request porcess
url = URI("#{STAGING_HOST}#{endpoint}")
https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true
request = Net::HTTP::Get.new(url)
request["Accept"] = "application/vnd.regalii.v3.2+json"
request["Content-Type"] = "application/json"
request["Content-MD5"] = content_md5
request["Date"] = timestamp
request["Authorization"] = "APIAuth #{APIKEY}:#{generated_checksum}"
response = https.request(request)

puts response.body
