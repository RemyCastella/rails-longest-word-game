require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @total_score = session[:total_score] || 0
    @letters = []
    until @letters.length == 10
      @letters << ("a".."z").to_a.sample
      @letters = @letters.uniq
    end
  end

  def score
    session[:total_score] ||= 0
    @total_score = session[:total_score]
    @score = 0
    @message = "Well done!"
    @letters = params[:letters].split("")
    @word = params[:word]
    url = "https://dictionary.lewagon.com/#{@word}"
    @response = JSON.parse(URI.parse(url).read)
    if @word.downcase.chars.all? { |char| @letters.include?(char) } && @response["found"]
      @score += @response["length"]
      session[:total_score] = session[:total_score] + @score
    elsif @response["found"]
      @score += 0
      @message = @response["error"]
    else
      @message = "Some of your letters are not allowed..."
    end
  end
end
