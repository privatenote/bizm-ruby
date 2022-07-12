# [BizM](https://www.bizmsg.kr/) client for ruby

```ruby
bizm = BizM.new(user_id, profile)
bizm.send(
  phone: '01012341234',
  msg: 'Welcome!',
  tmpl_id: 'template01',
  reserve_dt: '00000000000000',
  buttons: [{name: 'Go', url: 'https://www.bizmsg.kr/'}]
)
# reserve_dt가 '00000000000000'인 경우는 즉시 발송
```
