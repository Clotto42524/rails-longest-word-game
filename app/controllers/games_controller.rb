require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @attempt = params[:attempt]
    @grid = params[:grid].split(' ')
    run_game(@attempt, @grid)
  end

  def run_game(attempt, grid)
    attempt_array = attempt.upcase.chars
    if check_grid(attempt_array, grid)
      if parse_response(attempt)
        @message = "Congratulations! #{attempt.upcase} is a valid English word"
      else
        @message = "Sorry, but \"#{attempt.upcase}\" is not valid English word"
      end
    else
      @message = "Sorry, but \"#{attempt.upcase}\" cannot be built out of #{grid.join(', ')}"
    end
  end

  def check_grid(attempt, grid)
    attempt.all? { |letter| grid.count(letter) >= attempt.count(letter) }
  end

  def parse_response(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized = URI.open(url).read
    JSON.parse(serialized)['found']
  end
end
