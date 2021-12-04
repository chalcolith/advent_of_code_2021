use "collections"

class Day03Part2
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

    var oxy_rating: I64 = 0
    let oxy_indices = Set[USize].>union(Range[USize](0, num_lines))

    var co2_rating: I64 = 0
    let co2_indices = Set[USize].>union(Range[USize](0, num_lines))

    try
      for bit in Range[U64](U64.from[USize](max_bit), -1, -1) do
        let mask = I64.from[U64](1 << bit)
        var oxy_ones: USize = 0
        for idx in oxy_indices.values() do
          if (nums(idx)? and mask) != 0 then
            oxy_ones = oxy_ones + 1
          end
        end
        let oxy_zeros = oxy_indices.size() - oxy_ones
        if oxy_ones >= oxy_zeros then
          match _remove_nums(nums, oxy_indices, bit, 0)?
          | let idx: USize => oxy_rating = nums(idx)?
          end
        else
          match _remove_nums(nums, oxy_indices, bit, I64.from[U64](1 << bit))?
          | let idx: USize => oxy_rating = nums(idx)?
          end
        end

        var co2_ones: USize = 0
        for idx in co2_indices.values() do
          if (nums(idx)? and mask) != 0 then
            co2_ones = co2_ones + 1
          end
        end
        let co2_zeros = co2_indices.size() - co2_ones
        if co2_ones >= co2_zeros then
          match _remove_nums(nums, co2_indices, bit, I64.from[U64](1 << bit))?
          | let idx: USize => co2_rating = nums(idx)?
          end
        else
          match _remove_nums(nums, co2_indices, bit, 0)?
          | let idx: USize => co2_rating = nums(idx)?
          end
        end
      end
    end
    notify(oxy_rating * co2_rating)

  fun _remove_nums(nums: Array[I64], indices: Set[USize], bit: U64, mask: I64)
    : (USize | None) ?
  =>
    if indices.size() > 0 then
      let all_indices = Array[USize].>concat(indices.values())

      for idx in all_indices.values() do
        if (nums(idx)? and I64.from[U64](1 << bit)) == mask then
          indices.unset(idx)
        end
        if indices.size() == 1 then
          return indices.index(indices.next_index()?)?
        end
      end
    end
