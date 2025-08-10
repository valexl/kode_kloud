class LessonProgressProjector < Sequent::Core::Projector
  manages_tables UserLessonProgressRecord

  on Progress::Events::LessonStarted do |event|
    create_record(UserLessonProgressRecord, {
      aggregate_id: event.aggregate_id,
      user_id: event.user_id,
      lesson_id: event.lesson_id,
      course_id: event.course_id,
      status: "started"
    })
  end

  on Progress::Events::LessonCompleted do |event|
    update_all_records(
      UserLessonProgressRecord,
      event.attributes.slice(:aggregate_id),
      { status: "completed" }
    )
  end
end
