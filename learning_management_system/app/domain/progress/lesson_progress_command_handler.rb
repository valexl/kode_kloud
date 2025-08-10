module Progress
  class LessonProgressCommandHandler < Sequent::Core::BaseCommandHandler
    on Commands::StartLesson do |command|
      unless repository.contains_aggregate?(command.aggregate_id)
        repository.add_aggregate(
          Progress::LessonProgress.new(command)
        )
      end
    end

    on Commands::CompleteLesson do |command|
      do_with_aggregate(command, Progress::LessonProgress, &:complete)
    end
  end
end
