class Day01Part1
  fun apply(lines: Iterator[String iso^], out: OutStream, err: OutStream,
    notify: {val (I64)} val)
  =>
    var previous: I64 = I64.max_value()
    var total: I64 = 0
    for line in lines do
      try
        (let current, _) = line.read_int[I64]()?
        if current > previous then
          total = total + 1
        end
        previous = current
      else
        err.print("Day01Part1: error parsing line")
        return
      end
    end
    notify(total)
