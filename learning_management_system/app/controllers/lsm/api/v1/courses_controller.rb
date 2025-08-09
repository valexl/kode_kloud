module Lsm
  module Api
    module V1
      class CoursesController < BaseController
        def create
          course = Courses::CreateCourse.call(
            title: course_params[:title],
            description: course_params[:description]
          )

          render json: Courses::CourseSerializer.call(course), status: :created
        end

        private

        def course_params
          params.require(:course).permit(:title, :description)
        end
      end
    end
  end
end
