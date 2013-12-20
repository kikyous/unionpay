require 'test_helper'

class UnionPay::ServiceTest < Test::Unit::TestCase

  def test_generate_form
    param = {}
    param['transType']     = UnionPay::CONSUME                         #交易类型，CONSUME or PRE_AUTH
    param['orderAmount']   = 11000                                           #交易金额
    param['orderNumber']   = '20131220151706'
    param['customerIp']    = '127.0.0.1'
    param['frontEndUrl']   = "http://www.example.com/sdk/utf8/front_notify.php"    #前台回调URL
    param['backEndUrl']    = "http://www.example.com/sdk/utf8/back_notify.php"     #后台回调URL
    param['orderTime']     = '20131220151706'
    param['orderCurrency'] = UnionPay::CURRENCY_CNY                    #交易币种，CURRENCY_CNY=>人民币
    service = UnionPay::Service.front_pay(param)
    form = service.form(target: '_blank', id: 'form'){"<input type='submit' />"}
    assert_not_nil form
  end
end