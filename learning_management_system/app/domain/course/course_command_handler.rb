module Course
  class CourseCommandHandler < Sequent::CommandHandler
    on Commands::AddCourse do |command|
      repository.add_aggregate(
        Course.new(command)
      )
    end

    on Commands::ChangeCourseTitle do |command|
      do_with_aggregate(command, Course) do |course|
        course.change_title(command)
      end
    end

    on Commands::ChangeCourseDescription do |command|
      do_with_aggregate(command, Course) do |course|
        course.change_description(command)
      end
    end    

    on Commands::DeleteCourse do |command|
      do_with_aggregate(command, Course) do |course|
        course.delete
      end
    end
  end
end