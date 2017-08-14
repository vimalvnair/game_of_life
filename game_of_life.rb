# coding: utf-8
def generate_world
  row_limit = WORLD_SIZE[0]
  column_limit = WORLD_SIZE[1]

  world = []
  loop do
    break if world.size == row_limit
    column = []
    loop do
      break if column.size == column_limit
      column << rand(2)  
    end
    world << column
  end
  world
end

def next_generation world
  new_gen = world.map.with_index do |rval, row|
    rval.map.with_index do |val, col|
      next_generation_state row, col, world
    end
  end

  p = new_gen.map do |cell|
    cell.map do  |c|
      if c == 1
        "\e[32m👹\e[0m"
      else
        "\e[31m#{c}\e[0m"
        c
      end
    end.join("  ")
  end.join("\n\n")

  puts p
  new_gen
end

def next_generation_state row, col, world
  states = get_neighbour_cell_states row, col, world
  population = states.select{ |state| state >= 0 }.inject(:+).to_i
  if is_a_live_cell? row, col, world
    return 0 if under_populated? population
    return 0 if over_populated? population
    return 1 if normally_populated? population
  else
    return 1 if will_come_to_life? population
    return 0
  end
end

def get_neighbour_cell_states row, col, world
  row_limit = WORLD_SIZE[0] - 1
  column_limit = WORLD_SIZE[1] - 1
  neighbours = get_neighbour_cells row, col
  cells =  neighbours.map do |cell|
    row = cell[0]
    column = cell[1]
    if (row > row_limit) || (row < 0) || (column > column_limit) || (column < 0)
      -1
    else
      world[row][column]
    end
  end
  cells
end

def get_neighbour_cells row, col
  cells = [[row, col+1], [row, col-1], [row+1, col], [row-1, col], [row-1, col-1], [row+1, col+1], [row-1, col+1], [row+1, col-1]]
  cells
end

def is_a_live_cell? row, col, world
  world[row][col] == 1
end

def under_populated? population
  population < 2
end

def over_populated? population
  population > 3
end

def normally_populated? population
  (population == 2) || (population == 3)
end

def will_come_to_life? population
  population == 3
end

WORLD_SIZE = [20, 30]

system('clear')
world = generate_world
# world = [[0,0,0,0,0],
#          [0,0,1,1,1],
#          [0,1,1,1,0],
#          [0,0,0,0,0]]
loop do
  system('clear')
  world = next_generation(world)
  sleep 1
  system('clear')
  world = next_generation(world)
  sleep 1
end
