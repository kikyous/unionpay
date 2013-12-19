#encoding:utf-8
module UnionPay
  module Conf
    VERIFY_HTTPS_CERT = false

    Timezone = "Asia/Shanghai" #时区
    Sign_method = "md5" #摘要算法，目前仅支持md5 (2011-08-22)

    #Security_key = UnionPay.security_key #商户密钥

    # 支付请求预定义字段
    Pay_params = {
      'version' => '1.0.0',
      'charset' => 'UTF-8', #UTF-8, GBK等
      'merId'   => '88888888', #商户填写
      'acqCode' => '', #收单机构填写
      'merCode' => '', #收单机构填写
      'merAbbr' => '商户名称'
    }

    # 测试环境
    Front_pay_url = "http://58.246.226.99/UpopWeb/api/Pay.action"
    Back_pay_url = "http://58.246.226.99/UpopWeb/api/BSPay.action"
    Query_url = "http://58.246.226.99/UpopWeb/api/Query.action"

    ## 预上线环境
    #$front_pay_url = "https://www.epay.lxdns.com/UpopWeb/api/Pay.action"
    #$back_pay_url = "https://www.epay.lxdns.com/UpopWeb/api/BSPay.action"
    #$query_url = "https://www.epay.lxdns.com/UpopWeb/api/Query.action"
    #
    ## 线上环境
    #$front_pay_url = "https://unionpaysecure.com/api/Pay.action"
    #$back_pay_url = "https://besvr.unionpaysecure.com/api/BSPay.action"
    #$query_url = "https://query.unionpaysecure.com/api/Query.action"

    FRONT_PAY = 1
    BACK_PAY = 2
    RESPONSE = 3
    QUERY = 4

    CONSUME = "01"
    CONSUME_VOID = "31"
    PRE_AUTH = "02"
    PRE_AUTH_VOID = "32"
    PRE_AUTH_COMPLETE = "03"
    PRE_AUTH_VOID_COMPLETE = "33"
    REFUND = "04"
    REGISTRATION = "71"

    CURRENCY_CNY = "156"

    # 支付请求可为空字段（但必须填写）
    Pay_params_empty = {
      "origQid" => "",
      "acqCode" => "",
      "merCode" => "",
      "commodityUrl" => "",
      "commodityName" => "",
      "commodityUnitPrice" => "",
      "commodityQuantity" => "",
      "commodityDiscount" => "",
      "transferFee" => "",
      "customerName" => "",
      "defaultPayType" => "",
      "defaultBankNumber" => "",
      "transTimeout" => "",
      "merReserved" => ""
    }

    # 支付请求必填字段检查
    Pay_params_check = [
      "version",
      "charset",
      "transType",
      "origQid",
      "merId",
      "merAbbr",
      "acqCode",
      "merCode",
      "commodityUrl",
      "commodityName",
      "commodityUnitPrice",
      "commodityQuantity",
      "commodityDiscount",
      "transferFee",
      "orderNumber",
      "orderAmount",
      "orderCurrency",
      "orderTime",
      "customerIp",
      "customerName",
      "defaultPayType",
      "defaultBankNumber",
      "transTimeout",
      "frontEndUrl",
      "backEndUrl",
      "merReserved"
    ]

    # 查询请求必填字段检查
    $query_params_check = [
      "version",
      "charset",
      "transType",
      "merId",
      "orderNumber",
      "orderTime",
      "merReserved",
    ]

    # 商户保留域可能包含的字段
    Mer_params_reserved = [
      #  NEW NAME            OLD NAME
      "cardNumber", "pan",
      "cardPasswd", "password",
      "credentialType", "idType",
      "cardCvn2", "cvn",
      "cardExpire", "expire",
      "credentialNumber", "idNo",
      "credentialName", "name",
      "phoneNumber", "mobile",
      "merAbstract",

      #  tdb only
      "orderTimeoutDate",
      "origOrderNumber",
      "origOrderTime",
    ]

    Notify_param_check = [
      "version",
      "charset",
      "transType",
      "respCode",
      "respMsg",
      "respTime",
      "merId",
      "merAbbr",
      "orderNumber",
      "traceNumber",
      "traceTime",
      "qid",
      "orderAmount",
      "orderCurrency",
      "settleAmount",
      "settleCurrency",
      "settleDate",
      "exchangeRate",
      "exchangeDate",
      "cupReserved",
      "signMethod",
      "signature",
    ]

    Sign_ignore_params = [
      "bank",
    ]
  end
end
