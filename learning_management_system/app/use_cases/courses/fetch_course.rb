module Courses
  class FetchCourse
    attr_reader :aggregate_id

    def initialize(aggregate_id:)
      @aggregate_id = aggregate_id
    end

    def self.call(aggregate_id)
      new(aggregate_id:).call
    end

    def call
      CourseRecord.where(aggregate_id: aggregate_id).first!
    end
  end
end