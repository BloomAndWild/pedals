# Pedals
Ruby wrapper for Pedals Delivery API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pedals'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pedals

## Usage
------
#### Configure client
```ruby
Pedals::Client.configure do |config|
  logger = Logger.new(STDERR)
  logger.level = :debug

  config.base_url = ENV.fetch('BASE_URL')
  config.username = ENV.fetch('USERNAME')
  config.password = ENV.fetch('PASSWORD')
  config.logger = logger
end
```

## Quote
------

#### Create Quote

``` ruby
Pedals::Quote::CreateQuote.new(payload: {
  "pickup": {
    "address": "The pickup address",
    "postcode": "NW1 2LS",
    "lat": 51.5284878,
    "lng": -0.1290927
  },
  "dropoff": {
    "address": "The dropoff address",
    "postcode": "WC1B 3DG",
    "lat": 51.5191683,
    "lng": -0.1290927
  },
  "timing": "flexible",
  "earliestDeliveryTime": "2016-06-12T11:00:00Z",
  "latestDeliveryTime": "2016-06-12T12:00:00Z"
})
```
The call to above operation will return response object with two public methods.

``body`` - containing hash with the following data

``` ruby
{
  :id => 1234,
  :customer => 123,
  :pickup =>
  {
    :address => "The pickup address",:postcode => "NW1 2LS",
    :lat => 51.5284878, :lng => -0.1290927
  },
  :dropoffs => [
    {
      :address => "The dropoff address",
      :postcode => "WC1B 3DG",
      :lat => 51.5191683,
      :lng => -0.1290927
    }
  ],
  :timing => "flexible",:earliestDeliveryTime => "2016-06-12T11:00:00Z",
  :latestDeliveryTime => "2016-06-12T12:00:00Z",:distanceInMetres => 3166,
  :duration => 846,:price => 770,:dateCreated => "2016-06-12T08:00:00Z",
  :expiresOn => "2016-06-12T15:00:00Z"
}
```
``code`` - Status code e.g ``201``

Pedals API endpoint: https://test.pedals-delivery.com/api/v1/quotes

## Orders
------

#### Create Order

``` ruby
Pedals::Orders::CreateOrder.new(payload: {
  "quote": quote_id,
  "senderName": "Gandalf",
  "senderContact": "07700900776",
  "receiverName": "Elrond",
  "receiverContact": "02079460683",
  "description": "The One Ring",
  "specialInstructions": "Package weight fluctuates"
})
```
The call to above operation will return response object with two public methods.

``body`` - containing hash with the following data

``` ruby
{
  :id => order_id,
  :senderName => "Gandalf",
  :senderContact => "07700900776",
  :pickup =>
  {
    :address => "The pickup address",:postcode => "NW1 2LS",
    :lat => 51.5284878,:lng => -0.1290927
  },
  :receiverName => "Elrond",:receiverContact => "02079460683",
  :dropoff => {
    :address => "The dropoff address",:postcode => "WC1B 3DG",:lat => 51.5191683,:lng => -0.1290927
  },
  :earliestCollectionTime => "2016-06-12T10:40:00Z",
  :latestCollectionTime => "2016-06-12T11:40:00Z",
  :earliestDeliveryTime => "2016-06-12T11:00:00Z",
  :latestDeliveryTime => "2016-06-12T12:00:00Z",
  :specialInstructions => "Package weight fluctuates",
  :status => "available",
  :cyclist => {},
  :price => 770
}
```
``code`` - Status code e.g ``201``

Pedals API endpoint: https://test.pedals-delivery.com/api/v1/orders

#### Show Order

``` ruby
Pedals::Orders::ShowOrder.new(payload: {id: order_id})
```

The call to above operation will return response object with two public methods.

``body`` - containing hash with the following data

``` ruby
{
  :id => order_id,
  :senderName => "Gandalf",
  :senderContact => "07700900776",
  :pickup =>
  {
    :address => "The pickup address",:postcode => "NW1 2LS",
    :lat => 51.5284878,:lng => -0.1290927
  },
  :receiverName => "Elrond",:receiverContact => "02079460683",
  :dropoff =>
  {
    :address => "The dropoff address",:postcode => "WC1B 3DG",
    :lat => 51.5191683,:lng => -0.1290927
  },
  :earliestCollectionTime => "2016-06-12T10:40:00Z",
  :latestCollectionTime => "2016-06-12T11:40:00Z",
  :earliestDeliveryTime => "2016-06-12T11:00:00Z",
  :latestDeliveryTime => "2016-06-12T12:00:00Z",
  :specialInstructions => "Package weight fluctuates",
  :status => "available",
  :cyclist =>
  {
    :name => "Frodo",:contact => "01234 567890"
  },
  :price => 770
}
```
``code`` - Status code e.g ``200``

Pedals API endpoint: https://test.pedals-delivery.com/api/v1/orders/{order_id}

#### Cancel Order

``` ruby
Pedals::Orders::CancelOrder.new(payload: {"id": order_id})
```
The call to above operation will return response object with two public methods.

``body`` - containing hash with the following data

``` ruby
{
  :id => order_id,
  :status => "cancelled",
  :refundAmount => order_refund_amount
}

```
``code`` - Status code e.g ``200``
Pedals API endpoint: https://test.pedals-delivery.com/api/v1/orders/{order_id}

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pedals. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

