## Description

This client provides an easy way to interact with [version 2 of the Shutterstock, Inc. API](http://api.shutterstock.com) which gives you access to millions of photos, illustrations and footage clips. You will need a [Client ID and Client Secret from Shutterstock](https://developers.shutterstock.com/applications) to use this client.

The API operations are done within the context of a specific user/account. Below are some examples of how to use the API client.

**Currently, this API only supports Images, not videos or music.**

## Installation

Add this line to your application's Gemfile:

    gem 'shutterstock-v2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shutterstock-v2

## Quick Start

First, see the Authentication section to generate a client_id, client_secret and access_token

```ruby
require 'shutterstock-v2'

Shutterstock::Client.instance.configure do |config|
  config.client_id = "xxx"
  config.client_secret = "xxx"
  config.access_token = "xxx"
end

images = Shutterstock::Image.search("blue rose")
images.total_count
# => 170416
images.count   # Only returns first page of results
# => 20

image = images.first
image.id
# => 353732165
image.description
# => "close-up blue rose isolated on white background macro"

# License image for download, finding appropriate license from user's subscriptions
license = image.license

if !license.error
  `wget #{license.url}`
end

# Create a collection
collection = Shutterstock::Collection.create("blue rose")
# Add first page of results from our search to the collection
collection.add_image(images)
# Delete the collection
collection.destroy

```


## Configuration

Configuration is through a call to the `Shutterstock::Client` singleton. All subsequent calls will use these configuration options.

You can receive a [Client ID and Client Secret from Shutterstock](https://developers.shutterstock.com/applications). A non-expiring access_token can be generated through API calls. See the Authentication section below.

```ruby
require 'shutterstock-v2'

Shutterstock::Client.instance.configure do |config|
  config.client_id = "xxx"
  config.client_secret = "xxx"
  config.access_token = "xxx"
end
```


# Image

```ruby
image = Shutterstock::Image.find(118139110)
# => #<Shutterstock::Image>
image.assets
# => #<Shutterstock::ImageAssets>
image.assets.preview.url
# => "https://image.shutterstock.com/display_pic_with_logo/1306729/118139110/stock-photo-adorable-labrador-puppy-playing-with-a-chew-toy-on-white-backdrop-118139110.jpg
image.assets.huge.height
# => 3090

image.keywords
# => ["animal", "animal themes", "backgrounds", "cute", "dog", ...]

image.description
# => "Adorable Labrador Puppy Playing with a Chew Toy on White Backdrop"

image.adult?
# => false

# Requires editorial consent before licenseing
image.editorial?
# => false

image.similar
# => #<Shutterstock::Images>, an array of #<Shutterstock::Image>
# Currently only returns first page of results

image.similar.total_count        # total count of similar images
```

### Retrieving all image data

Some queries don't return full image data. Use `fill` to retrieve all data for a `Shutterstock::Image`

```ruby
# collection.items only returns image id's
first_collection_of_user = Shutterstock::Collection.list.first
image = first_collection_of_user.items.first

# Description isn't downloaded by default
image.description
# => nil

image.fill

image.description
# => "Rose Garden"
image.assets.preview.url
# => "http://...."

# .fill returns self, to help with chaining
image.fill.description

# .fill can also be used on a image list
images = Shutterstock::Collection.list.fill
images.first.description
```

## Searching for Images

```ruby
purple_cats = Shutterstock::Image.search("purple cat")
purple_cats.first.id
# => 431931730
```

Shutterstock has a strong searching capability. Pass a hash to utilize [all search parameters available](https://developers.shutterstock.com/api/v2/images/search).

```ruby
# one older japanese male teenager with a garden with a model release in landscape format
images = Shutterstock::Image.search({
  query: 'garden',
  people_number: 1,
  people_ethnicity: 'japanese',
  people_gender: 'male',
  people_age: 'teenagers',
  people_model_released: true,
  orientation: 'horizontal'})

images.first.assets.preview.url
```

![Image 529426645](https://image.shutterstock.com/display_pic_with_logo/692713/529426645/stock-photo-man-who-plant-a-garden-529426645.jpg)

## Image Licencing

To license an image for use, call `license` on a `Shutterstock::Image`. You'll receive a `Shutterstock::License` object back with any errors, the allotment from your plan, and the download url. `license` will find a valid subscription for the image size, and use that to purchase the image. Optionally specify the size (small, medium, huge, vector) and format (jpg, eps).

If an image requires editorial approval, `license` requests it.

```ruby
licensed = Image.find(553180399).license
licensed.allotment_charge   # 1 if not previously licensed, otherwise 0
licensed.url
# => "https://download.shutterstock.com/gatekeeper/abc/original.jpg"

# License the smallest asset of the image. Supports: small, medium, huge, vector. Default: huge.
licensed = Image.find(553180399).license(size: 'small')

# License the vector image
licensed = Image.find(553956103).license(size: 'vector', format: 'eps')
```

You can choose a specific subscription, or license multiple images through `Shutterstock::License`. See Subscriptions below.


# Collections

```ruby
collection = Shutterstock::Collection.find(21722255)  # get a collection
collection.items                                      # array of Shutterstock::Images

# metadata
collection.name                                       # name of collection
collection.cover_item                                 # Shutterstock::Image of cover image

## Create Collection
new_collection = Shutterstock::Collection.create("mynewcollection")

## Update Collection
new_collection.update(name: "updatename")

## Destroy Collection
new_collection.destroy

## Add Image to Collection
collection.add_image(987654321)
# or use any Shutterstock::Image object
collection.add_image(Image.find(12345))
# Can add multiple images
collection.add_image([1234, 2345, 3456])

## Remove image from Collection
collection.remove_image(987654321)

## Show all collections for current user (linked to access_token)
result = Shutterstock::Collection.list

```

If you don't have a `Shutterstock::Collection` object handy, call the class with a collection ID

```ruby
new_collection = Shutterstock::Collection.create("mynewcollection")
collection_id = new_collection.id
Shutterstock::Collection.update(id: collection_id, name: "updatename")
Shutterstock::Collection.destroy(id: collection_id)
Shutterstock::Collection.add_image(id: collection_id, image_id: 987654321)
Shutterstock::Collection.remove_image({id: collection_id, image_id: 987654321})
```

# Subscriptions

```ruby
# Find active (not expired) subscriptions for current user
subscriptions = Shutterstock::User.subscriptions.active
sub = subscriptions.first

sub.description
# => "Monthly Subscription"
sub.allotment.downloads_limit
# => 350
sub.allotment.downloads_left
# => 314
sub.has_downloads_left?
# => true

# Find a subscription for a specific image size
# Searches active subscriptions with downloads left
sub_id = Shutterstock::User.subscriptions.find_subscription_for_image_size('small').id
# => "s9999999"

# Images can be licensed using a subscription id
Shutterstock::License.license(subscription_id: sub_id, image_id: 1234)
Shutterstock::License.license(subscription_id: sub_id, image_id: Shutterstock::Image.find(1234))

# Optionally choose the size, format, or acknowledge the image will be used for editorial purposes
Shutterstock::License.license(subscription_id: sub_id, image_id: 1234, format: 'jpg', size: 'huge', editorial_acknowledgement: true)

# To specify metadata with the license request, use a hash
license_request = { image_id: 1234, metadata: { job: "job1", purchase_order: 'purchase order 1'}}
Shutterstock::License.license(subscription_id: sub_id, image_id: license_request)

# License multiple images by sending an array of image_ids, Shutterstock::Image objects, or hashes to license_multiple
licenses = Shutterstock::License.license_multiple(subscription_id: sub_id, image_id: [1234, 2345, 3456])
if !licenses.errors
  `wget #{licenses.first.url}`
end
```


# Authentication

To use this library, first [register an application at Shutterstock](https://developers.shutterstock.com/applications).

An access_token is needed. If your integration uses only one user account, you can follow the [single user integration](https://developers.shutterstock.com/guides/authentication#single-user-integration) directions to find the access_token.

Specify a `scope` to limit the queries that can be run by this token.

## Manually retrieve an access_token

```ruby
require 'shutterstock-v2'

puts "Retrieves access_token from Shutterstock API"
puts "First, create an application from this page:"
puts "https://developers.shutterstock.com/applications"
puts
puts "Enter Client ID"
client_id = gets.strip
puts
puts "Enter Client Secret"
client_secret = gets.strip

# Create configuration
Shutterstock::Client.instance.configure do |config|
  config.client_id = client_id
  config.client_secret = client_secret
end

puts "Requesting auth from Shutterstock..."
url = Shutterstock::Auth.get_authorize_url(redirect_uri: 'http://localhost',
                                           state: 'my_state',
                                           scope: 'licenses.create licenses.view purchases.view collections.view collections.edit')

puts
puts "Open this url in your process to complete the authication process :"
puts url
puts
puts "Authorize with your Shutterstock username/password."
puts
puts "You will be redirected to a localhost URL. Find the code= parameter in the URI"
puts "For example: http://localhost/?code=Dc4nSMazdKkFtk7AyBkSG3&state=my_state"
puts "Code is Dc4nSMazdKkFtk7AyBkSG3"
puts
puts "Enter the code= parameter here:"
code = gets.strip

begin
  result = Shutterstock::Auth.get_access_token(code: code)
  puts "You are now authenticated."
  puts
  puts "access_token is : #{result["access_token"]}"
  puts "Use this in the config section:"

  puts "Shutterstock::Client.instance.configure do |config|"
  puts "  config.client_id = '#{client_id}'"
  puts "  config.client_secret = '#{client_secret}'"
  puts "  config.access_token = '#{result["access_token"]}'"
  puts "end"
  puts
rescue Shutterstock::FailedResponse => e
  puts "Authentication failed : #{e.msg}"
end

```


# Tests

To run the tests using mocked responses, use
```ruby
rspec
```

To run the tests using making real API requests, use
```ruby
VCR_OFF=1 SSTK_CLIENT_ID=<clientid> SSTK_CLIENT_SECRET=<secret> SSTK_ACCESS_TOKEN=<token> rspec
```

Note: some tests will fail because they rely on new IDs supplied when the mocks were created.

When adding new test, uncomment options[:record] = :new_episodes line in `spec/spec-helper.rb`. And delete existing yml file

## Automation

If you would like to automatically run tests when files are chaged, run `bundle exec guard`.
This will monitor `lib` and `spec` and will run the appropriate tests. After a test runs, hit `ENTER` to re-run all tests.


# Based on v1 code

The structure of this API code was based on the [Shutterstock API Version 1](https://github.com/shutterstock/ruby-shutterstock-api).

Major changes:
- Using version 2 of the Shutterstock API
- switched to Faraday for http requests
- used rspec 3 expect format
- added objects to support Image class
- added subscriptions and purchasing

Limitations:

- Currently limited to first page of results
