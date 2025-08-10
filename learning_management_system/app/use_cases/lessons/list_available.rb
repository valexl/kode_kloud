module Lessons
  class ListAvailable
    def self.call
      new.call
    end

    def call
      LessonRecord.order(:id).map do |record|
        OpenStruct.new(
          aggregate_id: record.aggregate_id,
          course_id: record.course_id,
          title: record.title,
          description: record.description,
        )
      end
    end
  end
end