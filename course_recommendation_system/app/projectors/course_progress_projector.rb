class CourseProgressProjector < Sequent::Core::Projector
  manages_tables UserCourseProgressRecord

  on Progress::Events::CourseStarted do |event|
    create_record UserCourseProgressRecord, {
      aggregate_id: event.aggregate_id,
      user_id: event.user_id,
      course_id: event.course_id,
      status: "started"
    }
  end

  on Progress::Events::CourseCompleted do |event|
    update_all_records(
      UserCourseProgressRecord,
      event.attributes.slice(:aggregate_id),
      { status: "completed" }
    )
  end
end
