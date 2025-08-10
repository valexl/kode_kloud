module Crs
  module Api
    module V1
      class LmsEventsController < BaseController
        def create
          LmsEventsConsumer.call(params.permit!.to_h)
          head :accepted
        end
      end
    end
  end
end
