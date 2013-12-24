require 'test_helper'

class UnionPay::ServiceTest < Test::Unit::TestCase
  def generate_form
    param = {}
    param['transType']     = UnionPay::CONSUME                         #交易类型，CONSUME or PRE_AUTH
    param['orderAmount']   = 11000                                           #交易金额
    param['orderNumber']   = '20131220151706'
    param['customerIp']    = '127.0.0.1'
    param['frontEndUrl']   = "http://www.example.com/sdk/utf8/front_notify.php"    #前台回调URL
    param['backEndUrl']    = "http://www.example.com/sdk/utf8/back_notify.php"     #后台回调URL
    param['orderTime']     = '20131220151706'
    param['orderCurrency'] = UnionPay::CURRENCY_CNY                    #交易币种，CURRENCY_CNY=>人民币
    UnionPay::Service.front_pay(param)
  end

  def test_generate_form
    assert_not_nil generate_form.form(target: '_blank', id: 'form'){"<input type='submit' />"}
  end

  def test_generate_form_with_different_environment
    UnionPay.environment = :development
    dev_form = generate_form.form(target: '_blank', id: 'form'){"<input type='submit' />"}
    UnionPay.environment = :production
    pro_form = generate_form.form(target: '_blank', id: 'form'){"<input type='submit' />"}
    assert dev_form != pro_form
  end

  def test_responce
    params = {
      "charset" => "UTF-8", "cupReserved" => "", "exchangeDate" => "",
      "exchangeRate" => "", "merAbbr" => "银联商城（公司）", "merId" => "105550149170027",
      "orderAmount" => "9300", "orderCurrency" => "156", "orderNumber" => "D201312240006",
      "qid" => "201312241123141054552", "respCode" => "00", "respMsg" => "Success!",
      "respTime" => "20131224112352", "settleAmount" => "9300", "settleCurrency" => "156",
      "settleDate" => "1224", "traceNumber" => "105455", "traceTime" => "1224112314",
      "transType" => "01", "version" => "1.0.0", "signMethod" => "MD5",
      "signature" => "5b19db55d07290c739de97cb117ce884",
    #  "controller" => "front_money_payment_records", "action" => "unionpay_notify"
    }
    assert_not_nil UnionPay::Service.responce(params).args

  end

end