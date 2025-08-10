module Lsm
  module Api
    module V1
      class LessonsController < BaseController

        def index
          lessons = Lessons::ListAvailable.call

          render json: Lessons::LessonsSerializer.call(lessons), status: :ok
        end

        def show
          lesson = Lessons::FetchLesson.call(params[:id])

          render json: Lessons::LessonSerializer.call(lesson), status: :ok
        end

        def create
          lesson = Lessons::CreateLesson.call(
            title: lesson_params[:title],
            description: lesson_params[:description],
            course_id: lesson_params[:course_id]
          )

          render json: Lessons::LessonSerializer.call(lesson), status: :created
        end

        def update
          lesson = Lessons::UpdateLesson.call(
            aggregate_id: params[:id],
            title: lesson_params[:title],
            description: lesson_params[:description],
            course_id: lesson_params[:course_id]
          )

          render json: Lessons::LessonSerializer.call(lesson), status: :ok
        end

        def destroy
          Lessons::DeleteLesson.call(params[:id])
          head :no_content
        end

        private

        def lesson_params
          params.require(:lesson).permit(:title, :description, :course_id)
        end
      end
    end
  end
end
