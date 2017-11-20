class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end
end

def score
  @result = {score: 0}
  session[:score] = 0 unless session.key?(:score)
  if !ok_dico?(params[:word])
    @result[:message] = "Sorry but #{params[:word].upcase} doesn't seem to be a valid english word..."
  elsif !ok_grid?(params[:word], params[:grid])
    @result[:message] = "Sorry but #{params[:word].upcase} can't be built out of #{params[:grid].gsub(' ',',')}"
  else
    @result[:message] = "Congratulations! #{params[:word].upcase} is a valid english word."
    score = params[:word].length
    @result[:score] = score
    session[:score] += score
  end
end

def ok_dico?(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  api_answer_serialized = open(url).read
  api_answer_deserialized = JSON.parse(api_answer_serialized)
  return api_answer_deserialized['found']
end

def ok_grid?(word, grid)
  result = true
  hash_word = Hash.new(0)
  word.upcase.split('').each { |x| hash_word[x] += 1 }

  hash_grid = Hash.new(0)
  grid.split(' ').each { |x| hash_grid[x] += 1 }

  hash_word.each do |letter, occ|
    result = false if !hash_grid.key?(letter) || occ > hash_grid[letter]
  end
  return result
end
