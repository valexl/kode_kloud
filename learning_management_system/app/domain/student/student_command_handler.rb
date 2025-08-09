module Student
  class StudentCommandHandler < Sequent::CommandHandler
    on Commands::CreateStudent do |command|
      repository.add_aggregate Student.new(command)
    end

    on Commands::DeleteStudent do |command|
      do_with_aggregate(command, Student) do |student|
        student.delete
      end
    end
  end
end