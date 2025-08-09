module Course
  module Commands
    class AddCourse < Sequent::Command
      attrs title: String, description: String
      validates :title, presence: true
      validates :description, presence: true
    end

    class ChangeCourseTitle < Sequent::Command
      attrs title: String
      validates :title, presence: true
    end

    class ChangeCourseDescription < Sequent::Command
      attrs description: String
      validates :description, presence: true
    end

    class DeleteCourse < Sequent::Command; end
  end
end