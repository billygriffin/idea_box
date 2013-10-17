require 'sinatra/base'
require './lib/idea_box/idea_store'
require './lib/idea_box/idea'

class IdeaBoxApp < Sinatra::Base

  set :method_override, true
  set :root, 'lib/app'

  get '/' do
    erb :index, :locals => {ideas: IdeaStore.all.sort,
                            idea: Idea.new}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    puts "DELETE id: #{id}"
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, :locals => {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.data_hash)
    redirect '/'
  end

  get '/search' do
    matching_ideas = IdeaStore.search(params[:search])
    erb :search, locals: {matching_ideas: matching_ideas}
  end

  not_found do
    erb :error
  end
end
