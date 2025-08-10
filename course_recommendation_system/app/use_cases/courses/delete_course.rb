module Courses
  class DeleteCourse
    def self.call(course_id:)
      Sequent.command_service.execute_commands(
        ::Course::Commands::DeleteCourse.new(
          aggregate_id: course_id
        )
      )
    end
  end
end