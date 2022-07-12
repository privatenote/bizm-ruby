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
    button_url: nil,
    buttons: [],
    msg_sms: nil,
    sms_sender: nil
  )
    uri = URI.parse('https://alimtalk-api.bizmsg.kr/v2/sender/send')

    header = {
      'Content-type': 'application/json;charset=UTF-8',
      'userid': @user_id
    }

    data = {
      message_type: 'AT',
      phn: phone,
      profile: @profile,
      reserveDt: reserve_dt,
      msg: msg,
      tmplId: tmpl_id
    }

    if buttons.empty? && !button_name.nil?
      buttons << {
        name: button_name,
        url: button_url
      }
    end

    buttons.each_with_index do |button, index|
      data["button#{index + 1}".to_sym] = {
        name: button[:name],
        type: 'WL',
        url_mobile: button[:url]
      }
    end

    if msg_sms && sms_sender
      data[:smsKind] = 'S'
      data[:msgSms] = msg_sms
      data[:smsSender] = sms_sender
    end

    request = Net::HTTP::Post.new(uri.path, header)
    request.body = [data].to_json

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
