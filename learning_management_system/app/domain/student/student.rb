module Student
   class Student < Sequent::AggregateRoot
    def initialize(command)
      super(command.aggregate_id)
      apply Events::StudentCreated
    end

    def delete
      apply Events::StudentDeleted
    end

    on Events::StudentCreated do
    end

    on Events::StudentDeleted do
    end
  end
end