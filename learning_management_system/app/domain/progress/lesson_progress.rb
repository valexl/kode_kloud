module Progress
  class LessonProgress < Sequent::Core::AggregateRoot
    attr_reader :user_id, :lesson_id, :course_id, :status

    def initialize(command)
      super(command.aggregate_id)
      apply Events::LessonStarted, user_id: command.user_id, lesson_id: command.lesson_id, course_id: command.course_id, started_at: Time.now
    end

    def complete
      return if @status == "completed"
      apply Events::LessonCompleted, user_id: @user_id, lesson_id: @lesson_id, course_id: @course_id, completed_at: Time.now
    end

    on Events::LessonStarted do |event|
      return if @status == "started"
      @status = "started"
      @user_id = event.user_id
      @lesson_id = event.lesson_id
      @course_id = event.course_id
    end

    on Events::LessonCompleted do |_|
      @status = "completed"
    end
  end
end
