module Progress
  class ProgressCommandsHandler < Sequent::CommandHandler
    on Commands::StartCourse do |command|
      unless repository.contains_aggregate?(command.aggregate_id)
        repository.add_aggregate(
          Progress::CourseProgress.new(command)
        )
      end
    end

    on Commands::CompleteCourse do |command|
      do_with_aggregate(command, Progress::CourseProgress) do |aggregate|
        aggregate.complete
      end
    end
  end
end
