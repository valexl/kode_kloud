module Student
  module Events
    class StudentCreated < Sequent::Event; end
    class StudentDeleted < Sequent::Event; end
  end
end