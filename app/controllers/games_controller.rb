# frozen_string_literal: false
require 'open-uri'
require 'json'

# Controller for games
class GamesController < ApplicationController

  def new
    @letters = []
    1.upto 10 do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(" ")

    belongs = belongs_to_grid(@word, @letters)
    exists = search_word(@word)

    @message = message_maker(belongs, exists)
  end

  private

  def belongs_to_grid(word, grid)
    word.upcase!
    grid.map! { |char| char.upcase }
    belongs = true

    word.split('').each do |letter|
      grid.include?(letter) ? grid.delete_at(grid.index(letter)) : belongs = false
    end

    return belongs
  end

  def search_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}.upcase"
    dictionary_serialized = open(url).read
    dictionary = JSON.parse(dictionary_serialized)

    return dictionary["found"]
  end

  def message_maker(belongs, exists)
    if belongs && exists
      message = "Well done!"
    else
      message = "Not in the grid!\n" unless belongs
      message = "#{message}This is NOT an english word!" unless exists
      message = "#{message} \nYou can do better!"
    end

    return message
  end

end
