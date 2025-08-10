module Progress
  module Commands
    class StartCourse < Sequent::Command
      attrs course_id: String
      validates :course_id, presence: true
    end

    class CompleteCourse < Sequent::Command
      attrs course_id: String
      validates :course_id, presence: true
    end
  end
end