class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    lines = @puzzle_string.lines.map(&:chomp).reject { |line| line.include?('-') }
    grid = lines.map { |line| line.split('|').flat_map { |group| group.split.map(&:to_i) } }
    return "Sudoku is invalid." unless valid_numbers?(grid) && valid_rows?(grid) && valid_columns?(grid) && valid_subgrids?(grid)
    return "Sudoku is valid but incomplete." if grid.flatten.any?(&:zero?)
    "Sudoku is valid."
  end

  private

  def valid_numbers?(grid)
    grid.flatten.all? { |num| (0..9).include?(num) }
  end

  def valid_rows?(grid)
    grid.all? { |row| valid_group?(row) }
  end

  def valid_columns?(grid)
    grid.transpose.all? { |col| valid_group?(col) }
  end

  def valid_subgrids?(grid)
    (0..2).all? do |i|
      (0..2).all? do |j|
        subgrid = (0..2).flat_map { |x| (0..2).map { |y| grid[3*i + x][3*j + y] } }
        valid_group?(subgrid)
      end
    end
  end

  def valid_group?(group)
    nums = group.reject(&:zero?)
    nums == nums.uniq
  end
end
