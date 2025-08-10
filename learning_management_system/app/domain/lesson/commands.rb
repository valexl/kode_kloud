module Lesson
  module Commands
    class AddLesson < Sequent::Command
      attrs course_id: String, title: String, description: String
      validates :course_id, presence: true
      validates :title, presence: true
      validates :description, presence: true
    end

    class ChangeLessonTitle < Sequent::Command
      attrs title: String
      validates :title, presence: true
    end

    class ChangeLessonDescription < Sequent::Command
      attrs description: String
      validates :description, presence: true
    end

    class ChangeLessonCourse < Sequent::Command
      attrs course_id: String
      validates :course_id, presence: true
    end

    class DeleteLesson < Sequent::Command; end
  end
end