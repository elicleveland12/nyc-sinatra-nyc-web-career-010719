class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do

    erb :'/figures/new'
  end

  post '/figures' do
    binding.pry
    @figure = Figure.create(params[:name])
    if params[:title_ids] == nil && params[:landmark_ids] == nil
      @title = Title.create(params[:title][:name])
      FigureTitle.create(figure_id: @figure.id, title_id: @title.id)
    else
      params[:title_ids].each do |title_id|
      FigureTitle.create(figure_id: @figure.id, title_id: title_id.to_i)
    end
    if params[:landmark_ids] == nil
      @landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed], figure_id: @figure.id)
    else
      @landmark = Landmark.find(params[:landmark_ids])
      @landmark.update(figure_id = @figure.id)
    end 
  end
    redirect :"/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'/figures/show'
  end


  get '/figures/:id/edit' do

  end

end
