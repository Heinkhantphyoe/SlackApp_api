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

ActiveRecord::Schema[7.1].define(version: 2024_02_07_065954) do
  create_table "m_channels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "channel_name"
    t.boolean "channel_status"
    t.bigint "m_workspace_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_workspace_id", "created_at"], name: "index_m_channels_on_m_workspace_id_and_created_at"
    t.index ["m_workspace_id"], name: "index_m_channels_on_m_workspace_id"
  end

  create_table "m_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "profile_image"
    t.string "remember_digest"
    t.boolean "active_status"
    t.boolean "admin"
    t.boolean "member_status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "m_workspaces", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "workspace_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "t_direct_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "directmsg"
    t.boolean "read_status"
    t.integer "send_user_id"
    t.integer "receive_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["receive_user_id"], name: "index_t_direct_messages_on_receive_user_id"
    t.index ["send_user_id", "receive_user_id"], name: "index_t_direct_messages_on_send_user_id_and_receive_user_id"
    t.index ["send_user_id"], name: "index_t_direct_messages_on_send_user_id"
  end

  create_table "t_direct_star_msgs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userid"
    t.integer "directmsgid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["directmsgid"], name: "index_t_direct_star_msgs_on_directmsgid"
    t.index ["userid", "directmsgid"], name: "index_t_direct_star_msgs_on_userid_and_directmsgid", unique: true
    t.index ["userid"], name: "index_t_direct_star_msgs_on_userid"
  end

  create_table "t_direct_star_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userid"
    t.integer "directthreadid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["directthreadid"], name: "index_t_direct_star_threads_on_directthreadid"
    t.index ["userid", "directthreadid"], name: "index_t_direct_star_threads_on_userid_and_directthreadid", unique: true
    t.index ["userid"], name: "index_t_direct_star_threads_on_userid"
  end

  create_table "t_direct_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "directthreadmsg"
    t.boolean "read_status"
    t.bigint "t_direct_message_id"
    t.bigint "m_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_user_id", "created_at"], name: "index_t_direct_threads_on_m_user_id_and_created_at"
    t.index ["m_user_id"], name: "index_t_direct_threads_on_m_user_id"
    t.index ["t_direct_message_id", "created_at"], name: "index_t_direct_threads_on_t_direct_message_id_and_created_at"
    t.index ["t_direct_message_id"], name: "index_t_direct_threads_on_t_direct_message_id"
  end

  create_table "t_group_mention_msgs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userid"
    t.integer "groupmsgid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["groupmsgid"], name: "index_t_group_mention_msgs_on_groupmsgid"
    t.index ["userid", "groupmsgid"], name: "index_t_group_mention_msgs_on_userid_and_groupmsgid", unique: true
    t.index ["userid"], name: "index_t_group_mention_msgs_on_userid"
  end

  create_table "t_group_mention_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userid"
    t.integer "groupthreadid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["groupthreadid"], name: "index_t_group_mention_threads_on_groupthreadid"
    t.index ["userid", "groupthreadid"], name: "index_t_group_mention_threads_on_userid_and_groupthreadid", unique: true
    t.index ["userid"], name: "index_t_group_mention_threads_on_userid"
  end

  create_table "t_group_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "groupmsg"
    t.bigint "m_channel_id"
    t.bigint "m_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_channel_id"], name: "index_t_group_messages_on_m_channel_id"
    t.index ["m_user_id"], name: "index_t_group_messages_on_m_user_id"
  end

  create_table "t_group_star_msgs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userid"
    t.integer "groupmsgid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["groupmsgid"], name: "index_t_group_star_msgs_on_groupmsgid"
    t.index ["userid", "groupmsgid"], name: "index_t_group_star_msgs_on_userid_and_groupmsgid", unique: true
    t.index ["userid"], name: "index_t_group_star_msgs_on_userid"
  end

  create_table "t_group_star_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userid"
    t.integer "groupthreadid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["groupthreadid"], name: "index_t_group_star_threads_on_groupthreadid"
    t.index ["userid", "groupthreadid"], name: "index_t_group_star_threads_on_userid_and_groupthreadid", unique: true
    t.index ["userid"], name: "index_t_group_star_threads_on_userid"
  end

  create_table "t_group_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "groupthreadmsg"
    t.bigint "t_group_message_id"
    t.bigint "m_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_user_id", "created_at"], name: "index_t_group_threads_on_m_user_id_and_created_at"
    t.index ["m_user_id"], name: "index_t_group_threads_on_m_user_id"
    t.index ["t_group_message_id", "created_at"], name: "index_t_group_threads_on_t_group_message_id_and_created_at"
    t.index ["t_group_message_id"], name: "index_t_group_threads_on_t_group_message_id"
  end

  create_table "t_user_channels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "message_count"
    t.string "unread_channel_message"
    t.boolean "created_admin"
    t.integer "userid"
    t.integer "channelid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["channelid"], name: "index_t_user_channels_on_channelid"
    t.index ["userid", "channelid"], name: "index_t_user_channels_on_userid_and_channelid", unique: true
    t.index ["userid"], name: "index_t_user_channels_on_userid"
  end

  create_table "t_user_workspaces", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userid"
    t.integer "workspaceid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["userid", "workspaceid"], name: "index_t_user_workspaces_on_userid_and_workspaceid", unique: true
    t.index ["userid"], name: "index_t_user_workspaces_on_userid"
    t.index ["workspaceid"], name: "index_t_user_workspaces_on_workspaceid"
  end

  add_foreign_key "m_channels", "m_workspaces"
  add_foreign_key "t_direct_threads", "m_users"
  add_foreign_key "t_direct_threads", "t_direct_messages"
  add_foreign_key "t_group_messages", "m_channels"
  add_foreign_key "t_group_messages", "m_users"
  add_foreign_key "t_group_threads", "m_users"
  add_foreign_key "t_group_threads", "t_group_messages"
end
