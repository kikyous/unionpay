#encoding:utf-8
module UnionPay
  class << self
    attr_accessor :front_pay_url, :back_pay_url, :query_url
  end
  VERIFY_HTTPS_CERT = false

  Timezone = "Asia/Shanghai" #时区
  Sign_method = "md5" #摘要算法，目前仅支持md5 (2011-08-22)

  # 支付请求预定义字段
  PayParams = {
    'version' => '1.0.0',
    'charset' => 'UTF-8', #UTF-8, GBK等
    'merId'   => '88888888', #商户填写
    'acqCode' => '', #收单机构填写
    'merCode' => '', #收单机构填写
    'merAbbr' => '商户名称'
  }

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
  PayParamsEmpty = {
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
  PayParamsCheck = [
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
  QueryParamsCheck = [
    "version",
    "charset",
    "transType",
    "merId",
    "orderNumber",
    "orderTime",
    "merReserved",
  ]

  # 商户保留域可能包含的字段
  MerParamsReserved = [
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

  NotifyParamCheck = [
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

  SignIgnoreParams = [
    "bank",
  ]
end
