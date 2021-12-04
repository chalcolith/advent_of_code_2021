use "collections"

class Day01Part2
  fun apply(lines: Iterator[String iso^], out: OutStream, err: OutStream,
    notify: {val (I64)} val)
  =>
    let window_size: USize = 3

    var total: I64 = 0
    let data = Array[I64].init(I64.max_value() / 3, window_size + 1)
    var start_a: USize = 0
    var start_b: USize = 1

    for line in lines do
      (let current, _) =
        try
          line.read_int[I64]()?
        else
          err.print("Day01Part2: unable to parse line " + (consume line))
          return
        end
      try
        data((start_a + window_size) % data.size())? = current
      else
        err.print("Day01Part2: buffer overflow")
        return
      end

      var sum_a: I64 = 0
      for i in Range[USize](start_a, start_a + window_size) do
        sum_a =
          try
            sum_a + data(i % data.size())?
          else
            err.print("Day01Part2: invalid index i " + i.string())
            return
          end
      end
      var sum_b: I64 = 0
      for j in Range[USize](start_b, start_b + window_size) do
        sum_b =
          try
            sum_b + data(j % data.size())?
          else
            err.print("Day01Part2: invalid index j " + j.string())
            return
          end
      end
      if sum_b > sum_a then
        total = total + 1
      end
      start_a = (start_a + 1) % data.size()
      start_b = (start_b + 1) % data.size()
    end
    notify(total)
