use "files"

class Day01Part1
  fun apply(lines: Iterator[String iso^], out: OutStream, err: OutStream)
    : U32 ?
  =>
    var previous: U32 = U32.max_value()
    var total: U32 = 0
    for line in lines do
      (let current, _) = line.read_int[U32]()?
      if current > previous then
        total = total + 1
      end
      previous = current
    end
    total
