module Progress
  class CourseProgress < Sequent::Core::AggregateRoot
    attr_reader :user_id, :course_id, :status

    def initialize(command)
      super(command.aggregate_id)
      apply Events::CourseStarted, user_id: command.user_id, course_id: command.course_id
    end

    def complete
      return if @status == "completed"
      apply Events::CourseCompleted, user_id: @user_id, course_id: @course_id
    end

    on Events::CourseStarted do |event|
      @user_id = event.user_id
      @course_id = event.course_id
      @status = "started"
    end

    on Events::CourseCompleted do |_event|
      @status = "completed"
    end
  end
end
