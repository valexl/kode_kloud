class LmsEventsConsumer
  def self.call(payload)
    type = payload["type"]
    data = payload["data"]

    case type
    when "course_added"
      Courses::AddCourse.call(
        course_id: data["course_id"],
        title: data["title"],
        description: data["description"]
      )
    when "course_deleted"
      Courses::DeleteCourse.call(
        course_id: data["course_id"]
      )
    when "user_started_course"
      Progress::StartCourseForUser.call(
        user_id: data["user_id"],
        course_id: data["course_id"]
      )
    when "user_finished_course"
      Progress::CompleteCourseForUser.call(
        user_id: data["user_id"],
        course_id: data["course_id"]
      )
    end
  end
end
