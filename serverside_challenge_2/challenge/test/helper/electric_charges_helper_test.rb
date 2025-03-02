require "test_helper"

class ElectricityChargesHelperTest < ActionDispatch::IntegrationTest
  include ElectricChargesHelper
  test '[validate_params]正常系: 契約アンペア数 30A, 使用量 100kWh' do
    params = { ampere: "30", usage: "100" }
    assert_nil validate_params(params)
  end

  test '[validate_params]異常系: 契約アンペア数 0A' do
    params = { ampere: "0", usage: "100" }
    error, status = validate_params(params)
    assert_equal({ error: 'ampereの値が正しくありません' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: 使用量 -1kWh' do
    params = { ampere: "30", usage: "-1" }
    error, status = validate_params(params)
    assert_equal({ error: 'usageは0以上の整数を設定してください' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: 契約アンペア数 "abc" (型が不正)' do
    params = { ampere: "abc", usage: "100" }
    error, status = validate_params(params)
    assert_equal({ error: 'ampereの値が正しくありません' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: 使用量 "abc" (型が不正)' do
    params = { ampere: "30", usage: "abc" }
    error, status = validate_params(params)
    assert_equal({ error: 'usageは0以上の整数を設定してください' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: パラメータが空' do
    params = {}
    error, status = validate_params(params)
    assert_equal({ error: 'リクエストパラメータにampereとusageを設定してください' }, error)
    assert_equal :bad_request, status
  end
end