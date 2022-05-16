require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = (0...10).map { ('A'..'Z').to_a.sample }
  end

  def included?(attempt, array)
    attempt = attempt.upcase
    attempt.chars.all? do |lettre|
      attempt.count(lettre) <= array.count(lettre)
    end
  end

  def score
    @letters = params[:letters]
    url = "https://wagon-dictionary.herokuapp.com/#{params[:games]}"
    user_serialized = URI.open(url).read
    @result = JSON.parse(user_serialized)

    if @result['found'] && included?(params[:games], @letters)
      @message = "Congratulations ! #{params[:games]} is an valid english word."
    elsif included?(params[:games], @letters) == false
      @message = "Sorry, but #{params[:games]} is not in the grid"
    elsif @result['found'] == false
      @message = "Sorry, but #{params[:games]} is not an english word."
    end
  end
end
