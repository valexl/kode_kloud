module Progress
  class CourseProgress < Sequent::Core::AggregateRoot
    attr_reader :user_id, :course_id, :progress

    def initialize(command)
      super(command.aggregate_id)
      apply Events::CourseStarted, user_id: command.user_id, course_id: command.course_id
    end

    def set_progress(value)
      calculated_progress = [[value, 0].max, 100].min
      return if @progress == calculated_progress
      apply Events::CourseProgressUpdated, user_id: @user_id, course_id: @course_id, progress: calculated_progress
    end

    on Events::CourseStarted do |event|
      @user_id = event.user_id
      @course_id = event.course_id
      @progress = 0
    end

    on Events::CourseProgressUpdated do |event|
      @progress = event.progress
    end
  end
end
