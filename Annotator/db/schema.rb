# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130723113931) do

  create_table "annotations", :force => true do |t|
    t.string   "tweetId"
    t.string   "email"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "tweets", :force => true do |t|
    t.text    "content"
    t.string  "tweetId"
    t.integer "replies"
    t.string  "sarcastic"
    t.string  "reply_1"
    t.string  "reply_2"
    t.string  "reply_3"
    t.string  "reply_4"
    t.string  "reply_5"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.integer  "number_of_annotations"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "name"
    t.boolean  "admin",                 :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
