module Crs
  module Api
    module V1
      class LmsEventsController < BaseController
        skip_before_action :verify_authenticity_token

        def create
          LmsEventsConsumer.call(params.permit!.to_h)
          head :accepted
        end
      end
    end
  end
end
