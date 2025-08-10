module Crs
  module Api
    module V1
      class NextCourseController < BaseController
        def show
          course = Courses::RecommendNext.call(user_id: params[:id])
          if course
            render json: Courses::CourseSerializer.call(course), status: :ok
          else
            render json: { error: "no_course_available" }, status: :not_found
          end
        end
      end
    end
  end
end
