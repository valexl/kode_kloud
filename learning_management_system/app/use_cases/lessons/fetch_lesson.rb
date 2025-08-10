module Lessons
  class FetchLesson
    attr_reader :aggregate_id

    def initialize(aggregate_id:)
      @aggregate_id = aggregate_id
    end

    def self.call(aggregate_id)
      new(aggregate_id:).call
    end

    def call
      LessonRecord.where(aggregate_id: aggregate_id).first!
    end
  end
end