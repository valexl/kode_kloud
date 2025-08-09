module Course
  module Commands
    class AddCourse < Sequent::Command
      attrs title: String, description: String
      validates :title, presence: true
      validates :description, presence: true
    end
  end
end