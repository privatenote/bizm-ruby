require 'spec_helper'
require 'bizm'
require 'webmock/rspec'

RSpec.describe 'BizM' do
  let(:user_id) { 'user123' }
  let(:profile) { 'profile1' }
  let(:bizm) { BizM.new(user_id, profile) }

  let(:send_url) { 'https://alimtalk-api.bizmsg.kr/v2/sender/send' }
  let(:cancel_url) { 'https://alimtalk-api.bizmsg.kr/v2/sender/cancel_reserved' }
  let(:report_url) { 'https://alimtalk-api.bizmsg.kr/v2/sender/report' }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe 'send' do
    before do
      bizm.send(
        phone: '01012345678',
        msg: '[프라이빗노트 실시간수업] 복습영상이 등록되었습니다.',
        tmpl_id: 'pclass_video_uploaded',
        buttons: [
          {
            name: '확인하기',
            url: 'https://live.privatenote.co.kr/lectures',
            url_pc: 'https://live.privatenote.co.kr/lectures',
          },
        ],
      )
    end

    it '요청이 body가 잘 만들어져야 함' do
      expect(
        a_request(:post, send_url).with do |req|
          parsed = JSON.parse(req.body)
          return false unless parsed.is_a?(Array)

          data = parsed[0]
          data['phn'] == '01012345678' \
            && data['msg'] == '[프라이빗노트 실시간수업] 복습영상이 등록되었습니다.' \
            && data['tmplId'] == 'pclass_video_uploaded' \
            && data['profile'] == profile \
            && data['button1']['url_mobile'] == 'https://live.privatenote.co.kr/lectures'
        end
      ).to have_been_made.once
    end

    it '헤더에 userid가 포함되어야 함' do
      expect(a_request(:post, send_url).with { |req|
        req.headers['Userid'] == user_id
      }).to have_been_made.once
    end
  end
end