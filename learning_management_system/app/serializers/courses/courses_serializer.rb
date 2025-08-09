module Courses
  class CoursesSerializer
    def self.call(courses)
      courses.map do |course|
        CourseSerializer.call(course)
      end
    end
  end
end
