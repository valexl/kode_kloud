class CourseProgressProjector < Sequent::Core::Projector
  manages_tables UserCourseProgressRecord

  on Progress::Events::CourseStarted do |event|
    create_record UserCourseProgressRecord, {
      aggregate_id: event.aggregate_id,
      user_id: event.user_id,
      course_id: event.course_id,
      progress: 0
    }
  end

  on Progress::Events::CourseProgressUpdated do |event|
    update_all_records(
      UserCourseProgressRecord,
      event.attributes.slice(:aggregate_id),
      event.attributes.slice(:progress)
    )
  end
end
