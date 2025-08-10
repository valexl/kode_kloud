class LessonProjector < Sequent::Projector
  manages_tables LessonRecord

  on Lesson::Events::LessonAdded do |event|
    create_record(LessonRecord,
      aggregate_id: event.aggregate_id,
      course_id: event.course_id,
      title: event.title,
      description: event.description
    )
  end

  on Lesson::Events::LessonTitleChanged do |event|
    update_all_records(
      LessonRecord,
      event.attributes.slice(:aggregate_id),
      event.attributes.slice(:title)
    )
  end

  on Lesson::Events::LessonDescriptionChanged do |event|
    update_all_records(
      LessonRecord,
      event.attributes.slice(:aggregate_id),
      event.attributes.slice(:description)
    )
  end

  on Lesson::Events::LessonCourseChanged do |event|
    update_all_records(
      LessonRecord,
      event.attributes.slice(:aggregate_id),
      event.attributes.slice(:course_id)
    )
  end

  on Lesson::Events::LessonDeleted do |event|
    delete_all_records(
      LessonRecord,
      event.attributes.slice(:aggregate_id)
    )
  end
end