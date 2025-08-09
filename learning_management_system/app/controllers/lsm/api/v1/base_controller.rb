module Lsm
  module Api
    module V1
      class BaseController < ApplicationController
        protect_from_forgery with: :null_session

        rescue_from Sequent::Core::CommandNotValid do |e|
          render json: { error: e.errors }, status: :unprocessable_entity
        end
      end
    end
  end
end