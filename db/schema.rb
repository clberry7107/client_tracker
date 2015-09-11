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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150909231842) do

  create_table "artists", force: :cascade do |t|
    t.integer  "ArtistID"
    t.string   "ListName"
    t.string   "Url"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "EventID"
    t.string   "EventName"
    t.integer  "VenueID"
    t.string   "VenueName"
    t.integer  "CityID"
    t.string   "CityName"
    t.string   "State"
    t.string   "CountryName"
    t.string   "Region"
    t.string   "PlayDate"
    t.string   "Playtime"
    t.string   "Url"
    t.integer  "Venue_lat"
    t.integer  "Venue_long"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_artists", force: :cascade do |t|
    t.integer  "ArtistID"
    t.string   "ListName"
    t.integer  "ArtstType"
    t.integer  "MatchType"
    t.string   "Genre"
    t.string   "Url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_events", force: :cascade do |t|
    t.integer  "EventID"
    t.string   "EventName"
    t.integer  "VenueID"
    t.string   "VenueName"
    t.integer  "CityID"
    t.string   "CityName"
    t.string   "State"
    t.string   "CountryName"
    t.string   "Region"
    t.string   "PlayDate"
    t.string   "Playtime"
    t.string   "Url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "access_level"
    t.string   "user_type"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end