module Course
  class CourseCommandHandler < Sequent::CommandHandler
    on Commands::AddCourse do |command|
      repository.add_aggregate(
        Course.new(command)
      )
    end
  end
end