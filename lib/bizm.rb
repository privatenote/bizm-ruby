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
    message_type: 'AT',
    reserve_dt: '00000000000000',
    button_name: nil,
    button_url: nil,
    buttons: [],
    items: nil,
    header: nil,
    msg_sms: nil,
    sms_sender: nil
  )
    uri = URI.parse('https://alimtalk-api.bizmsg.kr/v2/sender/send')

    data = {
      message_type: message_type,
      phn: phone,
      profile: @profile,
      reserveDt: reserve_dt,
      header: header,
      items: items,
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
      button_data = {
        name: button[:name],
        type: 'WL',
        url_mobile: button[:url],
      }
      button_data.merge!(url_pc: button[:url_pc]) if button[:url_pc].present?

      data["button#{index + 1}".to_sym] = button_data
    end

    if msg_sms && sms_sender
      data[:smsKind] = msg_sms.bytesize > 90 ? 'L' : 'S'
      data[:msgSms] = msg_sms
      data[:smsSender] = sms_sender
    end

    request_header = {
      'Content-type': 'application/json;charset=UTF-8',
      'userid': @user_id
    }

    request = Net::HTTP::Post.new(uri.path, request_header)
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
      'userid': @user_id
    }
    data = {
      msgid: msg_id,
      profile: @profile,
    }
    request = Net::HTTP::Post.new(uri.path, header)
    request.set_form_data(data)  # This API doesn't accept JSON body

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)

    return JSON.parse(response.body)
  end
end
