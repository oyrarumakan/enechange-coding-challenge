require "test_helper"

class ElectricityCharges::CalculateControllerTest < ActionDispatch::IntegrationTest
  test '正常系: 契約アンペア数 10A, 使用量 0kWh' do
    get electricity_charges_calculate_url, params: { ampere: 10, usage: 0 }
    assert_response :success
    assert_equal({ 'total_charge' => 2000 }.to_json, response.body)
  end

  test '正常系: 契約アンペア数 30A, 使用量 100kWh' do
    get electricity_charges_calculate_url, params: { ampere: 30, usage: 100 }
    assert_response :success
    assert_equal({ 'total_charge' => 9000 }.to_json, response.body)
  end

  test '正常系: 契約アンペア数 60A, 使用量 500kWh' do
    get electricity_charges_calculate_url, params: { ampere: 60, usage: 500 }
    assert_response :success
    assert_equal({ 'total_charge' => 27000 }.to_json, response.body)
  end

  test '異常系: 契約アンペア数 0A' do
    get electricity_charges_calculate_url, params: { ampere: 0, usage: 100 }
    assert_response :bad_request
    assert_equal({ 'error' => 'ampereの値が正しくありません' }.to_json, response.body)
  end

  test '異常系: 契約アンペア数 70A' do
    get electricity_charges_calculate_url, params: { ampere: 70, usage: 100 }
    assert_response :bad_request
    assert_equal({ 'error' => 'ampereの値が正しくありません' }.to_json, response.body)
  end

  test '異常系: 使用量 -1kWh' do
    get electricity_charges_calculate_url, params: { ampere: 30, usage: -1 }
    assert_response :bad_request
    assert_equal({ 'error' => 'usageは0以上の整数を設定してください' }.to_json, response.body)
  end

  test '異常系: 使用量 1.5kWh (型が不正)' do
    get electricity_charges_calculate_url, params: { ampere: 30, usage: 1.5 }
    assert_response :bad_request
    assert_equal({ 'error' => 'usageは0以上の整数を設定してください' }.to_json, response.body)
  end

  test '異常系: 契約アンペア数 "abc" (型が不正)' do
    get electricity_charges_calculate_url, params: { ampere: "abc", usage: 100 }
    assert_response :bad_request
    assert_equal({ 'error' => 'ampereの値が正しくありません' }.to_json, response.body)
  end

  test '異常系: 使用量 "abc" (型が不正)' do
    get electricity_charges_calculate_url, params: { ampere: 30, usage: "abc" }
    assert_response :bad_request
    assert_equal({"error"=>"usageは0以上の整数を設定してください"}.to_json, response.body)
  end

  test '異常系: パラメータが空' do
    get electricity_charges_calculate_url, params: {}
    assert_response :bad_request
    assert_equal({"error"=>"リクエストパラメータにampereとusageを設定してください"}.to_json, response.body)
  end

  test "境界値分析: 契約アンペア数 10A, 使用量 0kWh (最小値)" do
    get electricity_charges_calculate_url, params: { ampere: 10, usage: 0 }
    assert_response :success
    assert_equal({ 'total_charge' => 2000 }.to_json, response.body)
  end
end
