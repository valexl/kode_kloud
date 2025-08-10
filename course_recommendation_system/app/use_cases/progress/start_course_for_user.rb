module Progress
  class StartCourseForUser
    def self.call(user_id:, course_id:)
      Sequent.command_service.execute_commands(
        ::Progress::Commands::StartCourse.new(
          aggregate_id: course_progress_aggregate_id(user_id, course_id),
          user_id: user_id,
          course_id: course_id
        )
      )
    end

    def self.course_progress_aggregate_id(user_id, course_id)
      (user_id.split("-")[0..1] + course_id.split("-")[2..-1]).join("-")
    end    
  end
end