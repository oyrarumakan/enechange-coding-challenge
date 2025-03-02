class ElectricityCharges::CalculateController < ApplicationController
  include ElectricChargesHelper
  def calc
    error, status = validate_params(params)
    if error
      return render json: error, status: status
    end

    # TODO: YAMLからパラメータ読み込み

    # TODO: レスポンス返却
    render json: {ampere: params[:ampere]}
  end
end
