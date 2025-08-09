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

        def update
          course = Courses::UpdateCourse.call(
            aggregate_id: params[:id],
            title: course_params[:title],
            description: course_params[:description]
          )

          render json: Courses::CourseSerializer.call(course), status: :ok
        end

        def destroy
          Courses::DeleteCourse.call(params[:id])
          head :no_content
        end

        private

        def course_params
          params.require(:course).permit(:title, :description)
        end
      end
    end
  end
end
