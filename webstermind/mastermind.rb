class Mastermind
  attr_reader :turn, :spot, :code, :board

  def initialize
    @turn = 0
  end

  def guess(guess)
    if guess == "ai"
      guess = @codebreaker.guess(@turn, @board.guesses, @board.feedback)
    end
    @board.update_guesses(guess)
    @board.update_feedback
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

  def initialize(code)
    @code = code
    @guesses = []
    @feedback = []
  end

  def update_feedback
    code = @code.dup
    guess = @guesses.last.dup
    @feedback << ""

    4.times do |i|
      if guess[i] == code[i]
        @feedback.last << "+"
        code[i] = "0"
        guess[i] = "1"
      end
    end

    4.times do |i|
      if code.include?(guess[i])
        @feedback.last << "-" 
        code[code.index(guess[i])] = "0"
        guess[i] = "1"
      end
    end

    (4 - @feedback.last.length).times { @feedback.last << " " }
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

    def guess(a, b, c)
      four_color_input
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
      @parsed_feedback = []
    end

    def guess(turn, guesses, feedback)
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
