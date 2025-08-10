module Progress
  class CourseProgressCommandHandler < Sequent::Core::BaseCommandHandler
    on Commands::StartCourse do |command|
      unless repository.contains_aggregate?(command.aggregate_id)
        repository.add_aggregate(
          Progress::CourseProgress.new(command)
        )
      end
    end

    on Commands::SetCourseProgress do |command|
      do_with_aggregate(command, Progress::CourseProgress) do |aggregate|
        aggregate.set_progress(command.progress)
      end
    end
  end
end
