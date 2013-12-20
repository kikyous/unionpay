require 'test/unit'
require 'unionpay'

UnionPay.environment = :development    ## 测试环境， :pre_production  #预上线环境， 默认 # 线上环境
UnionPay.mer_id = '105550149170027'
UnionPay.mer_abbr = '商户名称'
UnionPay.security_key = '88888888'
