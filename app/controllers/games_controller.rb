require 'open-uri'
require 'JSON'
require 'set'

class GamesController < ApplicationController
  def new
    letters = ('a'..'z').to_a
    @letters = Array.new(10) { letters.sample.upcase }

  end

  def score
    session[:score] = 0 if session[:score].nil?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    letter_array = params[:word].upcase.split("")
    @json_parse = JSON.parse(URI.open(url).read)
    @letters = params[:letters].split(",")
    #@score = params[:score].to_i

    if @json_parse["found"] == true && letter_array.all? {|x| @letters.include?(x)}
      @result = "Congratulations! #{params[:word]} is a valid English word!"
      session[:score] += letter_array.size * 2
    elsif letter_array.all? {|x| @letters.include?(x)} == false
      @result = "Sorry but #{params[:word]} can't be built out of #{@letters.join(", ")}"
      session[:score] = 0
    else
      @result = "Sorry but #{params[:word]} does not seem to be a valid English word."
      session[:score] = 0
    end
    @score = session[:score]

  end
end
