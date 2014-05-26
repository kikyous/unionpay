require 'test_helper'

class UnionPay::ServiceTest < Minitest::Test
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

  def generate_back_pay_service
    #交易类型 退货=REFUND 或 消费撤销=CONSUME_VOID, 如果原始交易是PRE_AUTH，那么后台接口也支持对应的
    #  PRE_AUTH_VOID(预授权撤销), PRE_AUTH_COMPLETE(预授权完成), PRE_AUTH_VOID_COMPLETE(预授权完成撤销)
    param = {}
    param['transType']             = UnionPay::REFUND
    param['origQid']               = '201110281442120195882'; #原交易返回的qid, 从数据库中获取
    param['orderAmount']           = 11000;        #交易金额
    param['orderNumber']           = '20131220151706'
    param['customerIp']            = '127.0.0.1';  #用户IP
    param['frontEndUrl']           = ""     #前台回调URL, 后台交易可为空
    param['backEndUrl']            = "http://www.example.com/sdk/utf8/back_notify.php"    #后台回调URL
    UnionPay::Service.back_pay(param)
  end

  def test_generate_form
    refute_nil generate_form.form(target: '_blank', id: 'form'){"<input type='submit' />"}
  end

  def test_front_pay_generate_form_with_different_environment
    UnionPay.environment = :development
    dev_form = generate_form.form(target: '_blank', id: 'form'){"<input type='submit' />"}
    UnionPay.environment = :pre_production
    pro_form = generate_form.form(target: '_blank', id: 'form'){"<input type='submit' />"}
    assert dev_form != pro_form
  end

  def test_back_pay_service
    dev_form = generate_back_pay_service
    refute_nil dev_form.post
  end
  def test_response
    test = {
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
    assert UnionPay::Service.response(test).args['respCode'] == UnionPay::RESP_SUCCESS
  end

  def test_query
    assert_raises RuntimeError, 'Bad signature returned!' do
      param = {}
      param['transType'] = UnionPay::CONSUME
      param['orderNumber'] = "20111108150703852"
      param['orderTime'] = "20111108150703"
      UnionPay.environment = :production
      query = UnionPay::Service.query(param)
      res = query.post
      UnionPay::Service.response res.body_str
    end
  end

end
