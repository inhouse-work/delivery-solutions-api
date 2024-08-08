# DeliverySolutions

`delivery_solutions` allows easy communication with the Delivery Solutions
API, enabling users to integrate last-mile delivery orchestration with their
online stores.

## Usage

### Testing with Fixtures

You can use the DeliverySolutionsAPI method `.stubbed_response` to get fixture
responses:

```ruby
  # This will return the default success fixture
  DeliverySolutionsAPI.stubbed_response("get_rates")
```

If you want to return a specific fixture, you'll have to specify a response
code:

```ruby
  # This will return the payload for a 400 error on a get_rates request
  DeliverySolutionsAPI.stubbed_response("get_rates", status_code: 400)
```

If you use the `.stubbed_response` without arguments, you'll receive
a `NotImplementedError` when you attempt to make requests. This is to ensure
that no live API calls are made through the test client, and forces users to
specify desired fixtures while testing.

Say you're testing the class below, and want to avoid making API calls, but
still need to have the returned data match your database data:

```ruby
class FetchRates
  def initialize(client:)
    @client = client
  end

  def call(**)
    @client.get_rates(**).payload.rates.each do |rate|
      Order.find_by!(storeExternalId: rate.storeExternalId)
    end
    # -> Response
  end
end
```

In order to stub the deeply nested rates so that they contain the correct data
to find your Orders, simply stub it out in your test framework:

```ruby
  instance_double(
    DeliverySolutionsAPI.test_client,
    **
  )
```

Then you can manipulate the data as you please:

```ruby
# RSpec example test
it "fetches delivery solutions rates and processes them" do
  get_rates = DeliverySolutionsAPI.stubbed_response("get_rates").tap do |response|
    response.payload.rates.map do |rate|
      rate.storeExternalId = "something"
    end
  end

  client = instance_double(
    DeliverySolutionsAPI.test_client,
    get_rates:
  )

  fetch_rates = Fetchrates.new(client:)
  response = fetch_rates.call(**)

  expect(response).to be_success
  expect(response.storeExternalId).to eq "something"
end
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
