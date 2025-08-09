module Courses
  class CourseSerializer
    def self.call(course)
      {
        id: course.aggregate_id,
        title: course.title,
        description: course.description
      }
    end
  end
end
