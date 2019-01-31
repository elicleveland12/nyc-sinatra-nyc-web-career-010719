class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    erb :'/figures/new'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:name])

    if params[:title_ids] == nil
      @title = Title.create(name: params[:title][:name])
      FigureTitle.create(figure_id: @figure.id, title_id: @title.id)
    else
      params[:title_ids].each do |title_id|
      FigureTitle.create(figure_id: @figure.id, title_id: title_id.to_i)
      end
    end

    if params[:landmark_ids] == nil
        @landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed], figure_id: @figure.id)
    else
      params[:landmark_ids].each do |landmark_id|
        @landmark = Landmark.find(landmark_id.to_i)
        @landmark.update(figure_id: @figure.id)
      end
    end

    redirect :"/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :"/figures/show"
  end


  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    erb :'/figures/edit'
  end

  patch '/figures/:id' do
    # binding.pry
    @figure = Figure.find(params[:id])

    if params[:title_ids] == nil
      @title = Title.create(name: params[:title][:name])
      FigureTitle.create(figure_id: @figure.id, title_id: @title.id)
    else
      FigureTitle.select(figure_id: @figure.id).each do |figure_title|
        figure_title.destroy
      end
      params[:title_ids].each do |title_id|
      FigureTitle.create(figure_id: @figure.id, title_id: title_id.to_i)
      end
    end

    Landmark.select(figure_id: @figure.id).each do |landmark|
      landmark.figure_id.delete
    end

    if params[:landmark_ids] == nil
        @landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed], figure_id: @figure.id)
    else
      params[:landmark_ids].each do |landmark_id|
        @landmark = Landmark.find(landmark_id.to_i)
        @landmark.update(figure_id: @figure.id)
      end
    end

    redirect "/figures/#{@figure.id}"
  end

end
