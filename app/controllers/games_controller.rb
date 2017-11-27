require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def play
    @letters = (Array.new(10) { ('A'..'Z').to_a.sample }).join(" ")
    @time_now = Time.now
  end

  def scores
    @letters = params[:letters].split(" ")
    @answer = params[:answer]
    @start_time = params[:start_time].to_time
    @end_time = Time.now
    @result = run_game(@answer, @letters, @start_time, @end_time)
  end


private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time - start_time }

    score_and_message = score_and_message(attempt, grid, result[:time])
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(attempt)
    response = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
