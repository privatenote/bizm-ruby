require 'net/http'
require 'net/https'
require 'json'

class BizM

  def initialize(user_id, profile)
    @user_id = user_id
    @profile = profile
  end

  def send(
    phone:,
    msg:,
    tmpl_id:,
    reserve_dt: '00000000000000',
    button_name: nil,
    button_url: nil
  )
    uri = URI.parse('https://alimtalk-api.bizmsg.kr/v2/sender/send')

    header = {
      'Content-type': 'application/json;charset=UTF-8',
      'userid': @user_id
    }
    if button_name
      data = [
        {
          message_type: 'AT',
          phn: phone,
          profile: @profile,
          reserveDt: reserve_dt,
          msg: msg,
          tmplId: tmpl_id,
          button1: {
            name: button_name,
            type: 'WL',
            url_mobile: button_url
          }
        }
      ]
    else
      data = [
        {
          message_type: 'AT',
          phn: phone,
          profile: @profile,
          reserveDt: reserve_dt,
          msg: msg,
          tmplId: tmpl_id
        }
      ]
    end
    request = Net::HTTP::Post.new(uri.path, header)
    request.body = data.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)

    return JSON.parse(response.body)[0]
  end

  def cancel(
    msg_id:
  )
    uri = URI.parse('https://alimtalk-api.bizmsg.kr/v2/sender/cancel_reserved')

    header = {
      'Content-type': 'application/json;charset=UTF-8',
      'userid': @user_id
    }
    data = {
      msgid: msg_id,
      profile: @profile,
    }
    request = Net::HTTP::Post.new(uri.path, header)
    request.body = data.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)

    return JSON.parse(response.body)
  end
end
