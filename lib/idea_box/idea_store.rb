require 'yaml/store'
require_relative './idea'

class IdeaStore
  def self.create(data)
    database.transaction do
      database['ideas'] << data
    end
  end

  def self.database
    return @database if @database

    @database = YAML::Store.new('db/ideabox')
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    idea = Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_by_tag(tag)
    all.select {|idea| idea.tags.include?(tag)}
  end

  def self.group_by_tag(tag)
    database.transaction do |db|
      ideas = db['ideas'].group_by {|idea| idea["tags"].include?(tag)}
      ideas[true]
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end
end

# idea = {"tags"=> ["tag1", "tag2", "tag 4"], "title"=>"idea 5", "description"=>"this is a test"}
# tag = "i am tag 3"
#
# IdeaStore.find(1)
