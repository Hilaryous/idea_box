require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb :error
  end

  def format_data(data)
    {"title"=> data["title"], "description"=> data["description"], "tags"=> data["tags"].split(", ")}
  end

  get '/' do
    erb :index
  end

  post '/' do
    idea = IdeaStore.create(format_data(params[:idea]))
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/new_idea' do
    erb :new_idea, locals: {idea: Idea.new(params)}
  end

  get '/existing_ideas' do
    erb :existing_ideas, locals: {ideas: IdeaStore.all.sort}
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  get '/:tag' do |tag|
    ideas = IdeaStore.find_by_tag(tag)
    erb :results, locals: {tag: tag, ideas: ideas}
  end

  put '/:id' do |id|

    IdeaStore.update(id.to_i, format_data(params[:idea]))
    redirect '/'
  end

  post '/:id/like' do |id|
    idea =  IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/existing_ideas'
  end
end
