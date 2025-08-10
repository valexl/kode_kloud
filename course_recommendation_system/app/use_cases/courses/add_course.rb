module Courses
  class AddCourse
    def self.call(course_id:, title:, description:)
      Sequent.command_service.execute_commands(
        ::Course::Commands::AddCourse.new(
          aggregate_id: course_id,
          title: title,
          description: description
        )
      )
    end
  end
end