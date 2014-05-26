unionpay
========

银联支付api

## Usage

### Install

```gem install unionpay```

### Config

```ruby
UnionPay.environment  = :development    ## 测试环境， :pre_production  #预上线环境， 默认 # 线上环境
UnionPay.mer_id       = '105550149170027'
UnionPay.mer_abbr     = '商户名称'
UnionPay.security_key = '88888888'
```

### Generate front payment form
```ruby
param = {}
param['orderAmount']  = 11000                                           #交易金额
param['orderNumber']  = Time.now.strftime('%Y%m%d%H%M%S')               #订单号，必须唯一
param['customerIp']   = '127.0.0.1'
param['frontEndUrl']  = "http://www.example.com/sdk/utf8/front_notify.php"    #前台回调URL
param['backEndUrl']   = "http://www.example.com/sdk/utf8/back_notify.php"     #后台回调URL

# 非必填字段
#   param['transType']          = UnionPay::CONSUME                            #交易类型，CONSUME or PRE_AUTH
#   param['commodityUrl']       = "http://www.example.com/product?name=商品"   #商品URL
#   param['commodityName']      = '商品名称'         # 商品名称
#   param['commodityUnitPrice'] = 11000             #商品单价
#   param['commodityQuantity']  = 1                 #商品数量
#

# 其余可填空的参数可以不填写

service = UnionPay::Service.front_pay(param)
service.args   ## get args
service.form(target: '_blank', id: 'form'){"<input type='submit' />"}  ## get form
```

### Verify notify

```ruby
# example in rails
# The notify url MUST be set when generate payment url
def unionpay_notify
  # except :controller_name, :action_name, :host, etc.
  notify_params = params.except(*request.path_parameters.keys)
  args = UnionPay::Service.response(notify_params).args
  if args['respCode'] == UnionPay::RESP_SUCCESS
    # valid notify, code your business logic.
    render :text => 'success'
  else
    render :text => 'error'
  end
end
```

### Generate back payment post params

```ruby
param = {}
# 交易类型 退货=REFUND 或 消费撤销=CONSUME_VOID, 如果原始交易是PRE_AUTH，那么后台接口也支持对应的
#  PRE_AUTH_VOID(预授权撤销), PRE_AUTH_COMPLETE(预授权完成), PRE_AUTH_VOID_COMPLETE(预授权完成撤销)
# param['transType']        = UnionPay::REFUND
param['origQid']          = '201110281442120195882' #原交易返回的qid, 从数据库中获取
param['orderAmount']      = 11000        #交易金额
param['orderNumber']      = '20131220151706'   #订单号，必须唯一(不能与原交易相同)
param['customerIp']       = '127.0.0.1'  #用户IP
param['frontEndUrl']      = ""     #前台回调URL, 后台交易可为空
param['backEndUrl']       = "http://www.example.com/sdk/utf8/back_notify.php"    #后台回调URL

service = UnionPay::Service.back_pay(param)
service.args   ## get args
res = service.post   ## do post
response = UnionPay::Service.response res.body
if response['respCode'] != UnionPay::RESP_SUCCESS
  raise("Error #{response['respCode']}: #{response['respMsg']}:")
end
```

### Query

```ruby
param = {}
param['transType'] = UnionPay::CONSUME
param['orderNumber'] = "20111108150703852"
param['orderTime'] = "20111108150703"
query = UnionPay::Service.query(param)
res = query.post
response = UnionPay::Service.response res.body

query_result = response['queryResult']
resp_code = response['respCode']

if query_result == UnionPay::QUERY_FAIL
  puts "交易失败[respCode:#{resp_code}]!"
elsif query_result == UnionPay::QUERY_INVALID
  puts "不存在此交易!"
elsif resp_code==UnionPay::RESP_SUCCESS && query_result == UnionPay::QUERY_SUCCESS
  puts '交易成功!'
elsif resp_code==UnionPay::RESP_SUCCESS && query_result == UnionPay::QUERY_WAIT
  puts '交易处理中，下次再查!'
end
```
