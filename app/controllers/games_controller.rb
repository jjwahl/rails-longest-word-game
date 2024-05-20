require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def check
    user_serialized = URI.open("https://dictionary.lewagon.com/#{@answer}").read
    user = JSON.parse(user_serialized)
    @result = user['found']
  end

  def check_in_grid
    @answer.chars.all? { |letter| @answer.count(letter) <= params[:grid].count(letter) }
  end


  def result
    if check && check_in_grid
      @score_message =  "Congratulations! #{@answer} is a valid word. Your score is #{@score}"
    elsif check_in_grid
      @score_message =  "Sorry, #{@answer} is not an english word"
    else
      @score_message =  "Sorry, #{@answer} cannot be built with #{params[:grid]}!"
    end
  end

  def score
    @answer = params[:answer].upcase
    @start_time = params[:time]
    @end_time = Time.now
    calc_score
    result
  end

  def calc_score
    sum = (@answer.size * 400_000_000) - (@end_time.to_i - @start_time.to_i)
    if sum.positive?
      @score = sum
    else
      @score = 0.001
    end
  end
end
