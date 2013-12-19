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

### Generate payment form
```ruby
param = {}
param['transType']    = UnionPay::CONSUME                         #交易类型，CONSUME or PRE_AUTH
param['orderAmount']  = 11000                                           #交易金额
param['orderNumber']  = Time.now.strftime('%Y%m%d%H%M%S')               #订单号，必须唯一
param['customerIp']   = '127.0.0.1'
param['frontEndUrl']  = "http://www.example.com/sdk/utf8/front_notify.php"    #前台回调URL
param['backEndUrl']   = "http://www.example.com/sdk/utf8/back_notify.php"     #后台回调URL

# 可填空字段
#   param['commodityUrl']       = "http://www.example.com/product?name=商品"   #商品URL
#   param['commodityName']      = '商品名称'         # 商品名称
#   param['commodityUnitPrice'] = 11000             #商品单价
#   param['commodityQuantity']  = 1                 #商品数量
#

# 其余可填空的参数可以不填写

UnionPay::Service.front_pay(param).form(target: '_blank', id: 'form'){"<input type='submit' />"}
```

### Verify notify

```ruby
# example in rails
# The notify url MUST be set when generate payment url
def unionpay_notify
  # except :controller_name, :action_name, :host, etc.
  notify_params = params.except(*request.path_parameters.keys)
  args = UnionPay::Service.responce(notify_params)
  if args['respCode'] == UnionPay::RESP_SUCCESS
    # valid notify, code your business logic.
    render :text => 'success'
  else
    render :text => 'error'
  end
end
```
