```ruby
kakao_msg = KakaoMsg.new
```
초기화를 해준 뒤
set_client와 send를 순서대로 실행
```ruby
kako_msg.set_client(user_id, profile)
```
```ruby
kakao_msg.send(
  phone:, msg:, tmpl_id:,
  reserve_dt: "00000000000000",
  button_name: nil, button_url: nil
)
```
reserve_dt가 "00000000000000"인 경우는 즉시 발송
