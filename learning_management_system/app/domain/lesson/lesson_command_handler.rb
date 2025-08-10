module Lesson
  class LessonCommandHandler < Sequent::CommandHandler
    on Commands::AddLesson do |command|
      repository.add_aggregate(
        Lesson.new(command)
      )
    end

    on Commands::ChangeLessonTitle do |command|
      do_with_aggregate(command, Lesson) do |lesson|
        lesson.change_title(command)
      end
    end

    on Commands::ChangeLessonDescription do |command|
      do_with_aggregate(command, Lesson) do |lesson|
        lesson.change_description(command)
      end
    end    

    on Commands::ChangeLessonCourse do |command|
      do_with_aggregate(command, Lesson) do |lesson|
        lesson.change_course(command)
      end
    end    

    on Commands::DeleteLesson do |command|
      do_with_aggregate(command, Lesson) do |lesson|
        lesson.delete
      end
    end
  end
end