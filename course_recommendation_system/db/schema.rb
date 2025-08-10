# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_08_10_100829) do
  create_schema "sequent_schema"
  create_schema "view_schema"

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aggregate_types", id: { type: :integer, limit: 2, default: nil }, force: :cascade do |t|
    t.text "type", null: false

    t.unique_constraint ["type"], name: "aggregate_types_type_key"
  end

  create_table "aggregate_unique_keys", primary_key: ["aggregate_id", "scope"], force: :cascade do |t|
    t.uuid "aggregate_id", null: false
    t.text "scope", null: false
    t.jsonb "key", null: false

    t.unique_constraint ["scope", "key"], name: "aggregate_unique_keys_scope_key_key"
  end

  create_table "aggregates", primary_key: "aggregate_id", id: :uuid, default: nil, force: :cascade do |t|
    t.text "events_partition_key", default: "", null: false
    t.integer "aggregate_type_id", limit: 2, null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["aggregate_type_id"], name: "aggregates_aggregate_type_id_idx"
    t.unique_constraint ["events_partition_key", "aggregate_id"], name: "aggregates_events_partition_key_aggregate_id_key"
  end

  create_table "aggregates_default", primary_key: "aggregate_id", id: :uuid, default: nil, force: :cascade do |t|
    t.text "events_partition_key", default: "", null: false
    t.integer "aggregate_type_id", limit: 2, null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["aggregate_type_id"], name: "aggregates_default_aggregate_type_id_idx"
    t.unique_constraint ["events_partition_key", "aggregate_id"], name: "aggregates_default_events_partition_key_aggregate_id_key"
  end

  create_table "aggregates_that_need_snapshots", primary_key: "aggregate_id", id: :uuid, default: nil, comment: "Contains a row for every aggregate with more events than its snapshot threshold.", force: :cascade do |t|
    t.integer "snapshot_sequence_number_high_water_mark", comment: "The highest sequence number of the stored snapshot. Kept when snapshot are deleted to more easily query aggregates that need snapshotting the most"
    t.timestamptz "snapshot_outdated_at", comment: "Not NULL indicates a snapshot is needed since the stored timestamp"
    t.timestamptz "snapshot_scheduled_at", comment: "Not NULL indicates a snapshot is in the process of being taken"
    t.index ["snapshot_outdated_at", "snapshot_sequence_number_high_water_mark", "aggregate_id"], name: "aggregates_that_need_snapshots_outdated_idx", order: { snapshot_sequence_number_high_water_mark: :desc }, where: "(snapshot_outdated_at IS NOT NULL)"
  end

  create_table "command_types", id: { type: :integer, limit: 2, default: nil }, force: :cascade do |t|
    t.text "type", null: false

    t.unique_constraint ["type"], name: "command_types_type_key"
  end

  create_table "commands", id: :bigint, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.uuid "user_id"
    t.uuid "aggregate_id"
    t.integer "command_type_id", limit: 2, null: false
    t.jsonb "command_json", null: false
    t.uuid "event_aggregate_id"
    t.integer "event_sequence_number"
    t.index ["aggregate_id"], name: "commands_aggregate_id_idx"
    t.index ["command_type_id"], name: "commands_command_type_id_idx"
    t.index ["event_aggregate_id", "event_sequence_number"], name: "commands_event_idx"
  end

  create_table "commands_default", id: :bigint, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.uuid "user_id"
    t.uuid "aggregate_id"
    t.integer "command_type_id", limit: 2, null: false
    t.jsonb "command_json", null: false
    t.uuid "event_aggregate_id"
    t.integer "event_sequence_number"
    t.index ["aggregate_id"], name: "commands_default_aggregate_id_idx"
    t.index ["command_type_id"], name: "commands_default_command_type_id_idx"
    t.index ["event_aggregate_id", "event_sequence_number"], name: "commands_default_event_aggregate_id_event_sequence_number_idx"
  end

  create_table "event_types", id: { type: :integer, limit: 2, default: nil }, force: :cascade do |t|
    t.text "type", null: false

    t.unique_constraint ["type"], name: "event_types_type_key"
  end

  create_table "events", primary_key: ["partition_key", "aggregate_id", "sequence_number"], force: :cascade do |t|
    t.uuid "aggregate_id", null: false
    t.text "partition_key", default: "", null: false
    t.integer "sequence_number", null: false
    t.timestamptz "created_at", null: false
    t.bigint "command_id", null: false
    t.integer "event_type_id", limit: 2, null: false
    t.jsonb "event_json", null: false
    t.bigint "xact_id", default: -> { "((pg_current_xact_id())::text)::bigint" }
    t.index ["command_id"], name: "events_command_id_idx"
    t.index ["event_type_id"], name: "events_event_type_id_idx"
  end

  create_table "events_default", primary_key: ["partition_key", "aggregate_id", "sequence_number"], force: :cascade do |t|
    t.uuid "aggregate_id", null: false
    t.text "partition_key", default: "", null: false
    t.integer "sequence_number", null: false
    t.timestamptz "created_at", null: false
    t.bigint "command_id", null: false
    t.integer "event_type_id", limit: 2, null: false
    t.jsonb "event_json", null: false
    t.bigint "xact_id", default: -> { "((pg_current_xact_id())::text)::bigint" }
    t.index ["command_id"], name: "events_default_command_id_idx"
    t.index ["event_type_id"], name: "events_default_event_type_id_idx"
  end

  create_table "saved_event_records", primary_key: ["aggregate_id", "sequence_number", "timestamp"], force: :cascade do |t|
    t.string "operation", limit: 1, null: false
    t.timestamptz "timestamp", null: false
    t.text "user", null: false
    t.uuid "aggregate_id", null: false
    t.text "partition_key", default: ""
    t.integer "sequence_number", null: false
    t.timestamptz "created_at", null: false
    t.bigint "command_id", null: false
    t.text "event_type", null: false
    t.jsonb "event_json", null: false
    t.bigint "xact_id"
    t.check_constraint "operation::text = ANY (ARRAY['U'::character varying, 'D'::character varying]::text[])", name: "saved_event_records_operation_check"
  end

  create_table "snapshot_records", primary_key: ["aggregate_id", "sequence_number"], force: :cascade do |t|
    t.uuid "aggregate_id", null: false
    t.integer "sequence_number", null: false
    t.timestamptz "created_at", null: false
    t.text "snapshot_type", null: false
    t.jsonb "snapshot_json", null: false
  end

  add_foreign_key "aggregate_unique_keys", "aggregates", primary_key: "aggregate_id", name: "aggregate_unique_keys_aggregate_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "aggregate_unique_keys", "aggregates_default", column: "aggregate_id", primary_key: "aggregate_id", name: "aggregate_unique_keys_aggregate_id_fkey1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "aggregates", "aggregate_types", name: "aggregates_aggregate_type_id_fkey", on_update: :cascade
  add_foreign_key "aggregates_default", "aggregate_types", name: "aggregates_aggregate_type_id_fkey", on_update: :cascade
  add_foreign_key "aggregates_that_need_snapshots", "aggregates", primary_key: "aggregate_id", name: "aggregates_that_need_snapshots_aggregate_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "aggregates_that_need_snapshots", "aggregates_default", column: "aggregate_id", primary_key: "aggregate_id", name: "aggregates_that_need_snapshots_aggregate_id_fkey1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "commands", "command_types", name: "commands_command_type_id_fkey", on_update: :cascade
  add_foreign_key "commands_default", "command_types", name: "commands_command_type_id_fkey", on_update: :cascade
  add_foreign_key "events", "aggregates", column: ["partition_key", "aggregate_id"], primary_key: ["events_partition_key", "aggregate_id"], name: "events_partition_key_aggregate_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "events", "aggregates_default", column: ["partition_key", "aggregate_id"], primary_key: ["events_partition_key", "aggregate_id"], name: "events_partition_key_aggregate_id_fkey1", on_update: :cascade, on_delete: :restrict
  add_foreign_key "events", "commands", name: "events_command_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "events", "commands_default", column: "command_id", name: "events_command_id_fkey1", on_update: :restrict, on_delete: :restrict
  add_foreign_key "events", "event_types", name: "events_event_type_id_fkey", on_update: :cascade
  add_foreign_key "events_default", "aggregates", column: ["partition_key", "aggregate_id"], primary_key: ["events_partition_key", "aggregate_id"], name: "events_partition_key_aggregate_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "events_default", "commands", name: "events_command_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "events_default", "event_types", name: "events_event_type_id_fkey", on_update: :cascade
  add_foreign_key "snapshot_records", "aggregates_that_need_snapshots", column: "aggregate_id", primary_key: "aggregate_id", name: "snapshot_records_aggregate_id_fkey", on_update: :cascade, on_delete: :cascade
end
