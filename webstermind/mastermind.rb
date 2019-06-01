class Mastermind
  attr_reader :board, :code, :codebreaker, :full_name_guesses

  def initialize
    @turn = 0
    @full_name_guesses = Array.new(12, "")
  end

  def guess(guess = nil)
    print "AM HERERERERERE"
    guess = @codebreaker.guess(@turn, @board.guesses, @board.feedback, guess)
    p guess
    @board.update_guesses(guess)
    @full_name_guesses[@turn] = full_names(@board.guesses[@turn])
    @board.update_feedback(@turn)
    @turn += 1
  end

  def choose_game_type(game_type)
    game_type == 'codemaster' ? codemaster_start : codebreaker_start
  end

  def create_code(code = "")
    @code = @codemaster.create_code(code)
  end

  def create_board(code)
    @board = Board.new(code)
  end

  def full_names(guess)
    result = []
    4.times do |i|
      current_color = guess[i]
      case current_color
      when 'B' then result << 'blue'
      when 'G' then result << 'green'
      when 'O' then result << 'orange'
      when 'P' then result << 'purple'
      when 'R' then result << 'red'
      when 'W' then result << 'white'
      end
    end
    result
  end

  private

  def codemaster_start
    @codemaster = Human::Codemaster.new
    @codebreaker = AI::Codebreaker.new
  end

  def codebreaker_start
    @codemaster = AI::Codemaster.new
    @codebreaker = Human::Codebreaker.new
  end
end

class Board
  attr_reader :guesses, :feedback
  attr_accessor :code

  def initialize(code)
    @code = code
    @guesses = []
    @feedback = Array.new(12) { "    " }
  end

  def update_feedback(turn)
    code = @code.dup
    guess = @guesses.last.dup
    result = []

    4.times do |i|
      if guess[i] == code[i]
        result << "+"
        code[i] = "0"
        guess[i] = "1"
      end
    end

    4.times do |i|
      if code.include?(guess[i])
        result << "-" 
        code[code.index(guess[i])] = "0"
        guess[i] = "1"
      end
    end

    (4 - result.length).times { result << " " }
    @feedback[turn] = result
  end

  def update_guesses(guess)
    @guesses << guess
  end

  def solved?
    @guesses.include?(@code)
  end
end

class Human
  class Codemaster < Human

    def create_code(code)
      code
    end
  end

  class Codebreaker < Human

    def guess(a, b, c, guess)
      guess
    end
  end
end

class AI

  def initialize
    @colors = ["B", "G", "O", "P", "R", "W"]
  end

  class Codemaster < AI

    def create_code(code)
      4.times { code << @colors[rand(6)] }
      code
    end
  end

  class Codebreaker < AI

    def initialize
      super
      @code_set = @colors.repeated_permutation(4).to_a.map { |x| x.join }
      p @code_set.size
      p @code_set.size
      p @code_set.size
      p @code_set.size
      p @code_set.size
      p @code_set.size
      @parsed_feedback = []
    end

    def guess(turn, guesses, feedback, guess)
      return "BBGG" if turn == 0
      @parsed_feedback << count_feedback(turn, feedback)
      eliminate_bad_guesses(turn, guesses)
      @code_set[0]
    end

    private

    def count_feedback(turn, feedback)
      result = [0, 0]
      4.times do |i|
        result[0] += 1 if feedback[turn-1][i] == "+"
        result[1] += 1 if feedback[turn-1][i] == "-"
      end
      result << result[0] + result[1]
    end

    def eliminate_bad_guesses(turn, guesses)
      @code_set -= [guesses.last]

      @code_set.reject! do |code|
        matches = 0
        perfect_matches = 0
        temp_code = code.dup
        result = false

        4.times do |i|
          if temp_code.include?(guesses.last[i])
            matches += 1
            temp_code.sub!(/#{guesses.last[i]}/, "0")
          end
          perfect_matches += 1 if code[i] == guesses.last[i]
        end

        result = true if matches != @parsed_feedback.last[2] ||
                         perfect_matches != @parsed_feedback.last[0]
      end
    end
  end
end
