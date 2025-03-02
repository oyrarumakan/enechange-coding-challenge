module ElectricChargesHelper
  VALID_CONTRACT_AMPERES = %w(10 15 20 30 40 50 60).freeze
  VALID_USAGE_REGEX = /\A\d+\z/.freeze

  # リクエストパラメータのバリデーション
  def validate_params(request_params)
    # パラメータが不足しているとき
    if request_params[:ampere].nil? || request_params[:usage].nil?
      return { error: I18n.t('errors.empty_parameter') }, :bad_request
    end

    # ampereは特定値である必要がある
    unless VALID_CONTRACT_AMPERES.include?(request_params[:ampere])
      return { error: I18n.t('errors.invalid_contract_ampere') }, :bad_request
    end

    # usageは0以上の整数である必要がある
    usage = request_params[:usage].to_i
    unless VALID_USAGE_REGEX.match?(request_params[:usage])
      return { error: I18n.t('errors.invalid_usage') }, :bad_request
    end
    if usage < 0
      return { error: I18n.t('errors.invalid_usage') }, :bad_request
    end

    nil
  end

  # yamlからパラメータ読み込み
  def import_price_from_yaml(ampere)
    # 基本料金
    Rails.configuration.electricty_charges
  end
end
