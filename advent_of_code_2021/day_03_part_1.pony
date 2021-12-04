use "collections"

class Day03Part1
  fun apply(lines: Iterator[String iso^], out: OutStream, err: OutStream,
    notify: {val (I64)} val)
  =>
    let nums = Array[I64]
    var max_bit: USize = 0
    var i: USize = 0
    for line in lines do
      if line.size() == 0 then continue end
      try
        let bit = line.size() - 1
        if bit > max_bit then
          max_bit = bit
        end
        nums.push(line.read_int[I64](0 where base = 2)?._1)
      else
        err.print("Day03Part1: error in line " + (i+1).string())
        return
      end
      i = i + 1
    end
    let num_lines = i

    var gamma: I64 = 0
    var epsilon: I64 = 0
    for bit in Range[U64](U64.from[USize](max_bit), -1, -1) do
      var num_ones: USize = 0
      for num in nums.values() do
        if (num and I64.from[U64](1 << bit)) != 0 then
          num_ones = num_ones + 1
        end
      end
      let num_zeros = num_lines - num_ones
      gamma = gamma << 1
      epsilon = epsilon << 1
      if num_ones >= num_zeros then
        gamma = gamma or 1
      else
        epsilon = epsilon or 1
      end
    end
    notify(gamma * epsilon)
