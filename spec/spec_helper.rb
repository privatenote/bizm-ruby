require 'simplecov'
require 'simplecov_json_formatter'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
])

SimpleCov.start do
  enable_coverage :branch
  track_files '{app, lib}/**/*.rb'
  add_filter '/spec/'
end

require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, %r{alimtalk-api.bizmsg.kr/v2/sender/send})
      .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
      .to_return do |request|
        {
          status: 200,
          body: JSON.parse(request.body).map do |body|
            {
              code: 'success',
              data: {
                phn: body['phn'],
                msgid: 'WEB1234',
                type: 'AT',
              },
              message: 'K000',
              originalMessage: nil,
            }
          end.to_json,
          headers: { 'Content-Type': 'application/json' },
        }
      end

    stub_request(:post, %r{alimtalk-api.bizmsg.kr/v2/sender/cancel_reserved})
      .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
      .to_return do |_request|
        {
          status: 200,
          body: {}.to_json,
          headers: { 'Content-Type': 'application/json' },
        }
      end

    stub_request(:get, %r{alimtalk-api.bizmsg.kr/v2/sender/report})
      .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
      .to_return do |_request|
        {
          status: 200,
          body: {
            code: 'success',
            data: { msgid: 'WEB1234' },
            message: 'M000'
          },
          headers: { 'Content-Type': 'application/json' },
        }
      end
  end
end