module Courses
  class ListAvailable
    def self.call
      new.call
    end

    def call
      CourseRecord.order(:id).map do |record|
        OpenStruct.new(
          aggregate_id: record.aggregate_id,
          title: record.title,
          description: record.description

        )
      end
    end
  end
end