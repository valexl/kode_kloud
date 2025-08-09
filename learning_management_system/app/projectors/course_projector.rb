class CourseProjector < Sequent::Projector
  manages_tables CourseRecord

  on Course::Events::CourseAdded do |event|
    create_record(CourseRecord,
      aggregate_id: event.aggregate_id,
      title: event.title,
      description: event.description
    )
  end

  on Course::Events::CourseTitleChanged do |event|
    update_all_records(
      CourseRecord,
      event.attributes.slice(:aggregate_id),
      event.attributes.slice(:title)
    )
  end

  on Course::Events::CourseDescriptionChanged do |event|
    update_all_records(
      CourseRecord,
      event.attributes.slice(:aggregate_id),
      event.attributes.slice(:description)
    )
  end

  on Course::Events::CourseDeleted do |event|
    delete_all_records(
      CourseRecord,
      event.attributes.slice(:aggregate_id)
    )
  end
end