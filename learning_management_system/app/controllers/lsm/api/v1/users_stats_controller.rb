module Lsm
  module Api
    module V1
      class UsersStatsController < ApplicationController
        def show
          stats = Stats::UserStats.call(user_id: params[:id])
          render json: Stats::UserStatsSerializer.call(stats), status: :ok
        end
      end
    end
  end
end