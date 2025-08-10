module Lsm
  module Api
    module V1
      class LessonsProgressController < ApplicationController
        def start
          lesson_progress = Progresses::StartLesson.call(
            lesson_id: params[:id],
            course_id: params[:course_id],
            user_id:   user_id
          )

          render json: Progresses::LessonProgressSerializer.call(lesson_progress), status: :accepted

        end

        def complete
          lesson_progress = Progresses::CompleteLesson.call(
            lesson_id: params[:id],
            course_id: params[:course_id],
            user_id:   user_id
          )

          render json: Progresses::LessonProgressSerializer.call(lesson_progress), status: :accepted
        end

        private

        def user_id
          params.permit(:user_id).require(:user_id)
        end
      end
    end
  end
end
