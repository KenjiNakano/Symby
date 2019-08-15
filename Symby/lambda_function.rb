require './Symby'
require 'json'

def lambda_handler(event:, context:)
    two = Number.new(2)
    three = Number.new(3)
    addtwothree = two + three
    { statusCode: 200, body: JSON.generate("Hello! " + addtwothree.to_s)}
end


