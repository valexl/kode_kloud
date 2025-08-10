class IntegrationEventsWorkflow < Sequent::Workflow
  def publisher
    @publisher ||= HttpIntegrationEventPublisher.new(
      url: ENV.fetch("INTEGRATION_EVENTS_URL")
    )
  end

  on ::Course::Events::CourseAdded do |event|
    publisher.publish(
      type: "course_added",
      data: { course_id: event.aggregate_id, title: event.title, description: event.description }
    )
  end

  on ::Course::Events::CourseDeleted do |event|
    publisher.publish(
      type: "course_deleted",
      data: { course_id: event.aggregate_id }
    )
  end

  on ::Progress::Events::CourseStarted do |event|
    publisher.publish(
      type: "user_started_course",
      data: { user_id: event.user_id, course_id: event.course_id }
    )
  end

  on ::Progress::Events::CourseProgressUpdated do |event|
    if event.progress.to_i >= 100
      publisher.publish(
        type: "user_finished_course",
        data: { user_id: event.user_id, course_id: event.course_id }
      )
    end
  end
end
