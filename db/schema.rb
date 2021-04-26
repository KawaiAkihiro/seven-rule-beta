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

ActiveRecord::Schema.define(version: 2021_04_26_061412) do

  create_table "individual_shifts", charset: "utf8", force: :cascade do |t|
    t.datetime "start"
    t.datetime "finish"
    t.boolean "Temporary", default: false, null: false
    t.boolean "deletable", default: false, null: false
    t.string "mode"
    t.string "plan"
    t.bigint "staff_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "next_staff_id"
    t.index ["staff_id"], name: "index_individual_shifts_on_staff_id"
  end

  create_table "masters", charset: "utf8", force: :cascade do |t|
    t.string "store_name"
    t.string "user_name"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "shift_onoff", default: false, null: false
    t.integer "staff_number"
    t.string "email"
    t.boolean "onoff_email", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "submits_start"
    t.datetime "submits_finish"
  end

  create_table "notices", charset: "utf8", force: :cascade do |t|
    t.string "mode"
    t.integer "shift_id"
    t.integer "staff_id"
    t.string "comment"
    t.bigint "master_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["master_id"], name: "index_notices_on_master_id"
  end

  create_table "patterns", charset: "utf8", force: :cascade do |t|
    t.time "start"
    t.time "finish"
    t.bigint "staff_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["staff_id"], name: "index_patterns_on_staff_id"
  end

  create_table "shift_separations", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.time "start_time"
    t.time "finish_time"
    t.bigint "master_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["master_id"], name: "index_shift_separations_on_master_id"
  end

  create_table "staffs", charset: "utf8", force: :cascade do |t|
    t.string "staff_name"
    t.integer "staff_number"
    t.boolean "training_mode"
    t.string "password_digest"
    t.bigint "master_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "abandon", default: false, null: false
    t.index ["master_id", "created_at"], name: "index_staffs_on_master_id_and_created_at"
    t.index ["master_id"], name: "index_staffs_on_master_id"
  end

  add_foreign_key "individual_shifts", "staffs"
  add_foreign_key "notices", "masters"
  add_foreign_key "patterns", "staffs"
  add_foreign_key "shift_separations", "masters"
  add_foreign_key "staffs", "masters"
end
