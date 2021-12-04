use "collections"

class Day02Part2
  fun apply(lines: Iterator[String iso^], out: OutStream, err: OutStream,
    notify: {val (I64)} val)
  =>
    let command_line_rule = Day02Grammar.command_line()
    let result_collector = _Day02Part2ResultCollector(err, notify)

    var i: USize = 0
    for line in lines do
      let line' = recover val line.clone() end
      let parser = Parser([ line' ])
      parser.parse(command_line_rule, None,
        {(result, value) =>
          match result
          | let success: Success =>
            match value
            | let command: Command =>
              result_collector.collect(i, command)
            else
              err.print("Day02Part2: invalid command at line " + (i+1).string()
                + " '" + line' + "'")
            end
          | let failure: Failure =>
            err.print("Day02Part2: failed to parse line " + (i+1).string()
              + " '" + line' + "': " + failure.get_message())
          end
        })
      i = i + 1
    end
    result_collector.set_num_needed(i)

actor _Day02Part2ResultCollector
  let _err: OutStream
  let _results: Map[USize, Command] = Map[USize, Command]
  var _num_needed: (USize | None) = None
  let _notify: {val (I64)} val

  new create(err: OutStream, notify: {val (I64)} val) =>
    _err = err
    _notify = consume notify

  be collect(i: USize, command: Command) =>
    _results(i) = command
    _check_done()

  be set_num_needed(num: USize) =>
    _num_needed = num
    _check_done()

  fun _check_done() =>
    match _num_needed
    | let n: USize =>
      if _results.size() == n then
        var horiz: I64 = 0
        var depth: I64 = 0
        var aim: I64 = 0
        for i in Range[USize](0, n) do
          try
            let command = _results(i)?
            match command.direction
            | Forward =>
              horiz = horiz + command.distance
              depth = depth + (aim * command.distance)
            | Down => aim = aim + command.distance
            | Up => aim = aim - command.distance
            | None => _err.print("null direction in command")
            end
          else
            _err.print("error in _ResultCollector._check_done()")
          end
        end

        _notify(horiz * depth)
      end
    end
