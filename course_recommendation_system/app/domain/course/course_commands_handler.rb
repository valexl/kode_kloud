module Course
  class CourseCommandsHandler < Sequent::CommandHandler
    on Commands::AddCourse do |command|
      repository.add_aggregate(
        Course.new(command)
      )
    end

    on Commands::DeleteCourse do |command|
      do_with_aggregate(command, Course) do |course|
        course.delete
      end
    end
  end
end
