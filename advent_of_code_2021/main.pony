use "files"

interface DayTask
  fun apply(lines: Iterator[String iso^], out: OutStream, err: OutStream,
    notify: {val (I64)} val)

actor Main
  new create(env: Env) =>
    try
      run("D01P1e", "data/day_01_example.txt", Day01Part1, env, 7)?
      run("D01P1", "data/day_01_data.txt", Day01Part1, env, 1581)?
      run("D01P2e", "data/day_01_example.txt", Day01Part2, env, 5)?
      run("D01P2", "data/day_01_data.txt", Day01Part2, env, 1618)?
      run("D02P1e", "data/day_02_example.txt", Day02Part1, env, 150)?
      run("D02P1", "data/day_02_data.txt", Day02Part1, env, 1762050)?
      run("D02P2e", "data/day_02_example.txt", Day02Part2, env, 900)?
      run("D02P2", "data/day_02_data.txt", Day02Part2, env, 1855892637)?
    else
      env.exitcode(1)
    end

  fun run(name: String, fname: String, task: DayTask, env: Env,
    expected: I64) ?
  =>
    try

      let fpath = FilePath(env.root as AmbientAuth, fname)
      match OpenFile(fpath)
      | let file: File =>
        task(FileLines(file), env.out, env.err,
          {(n: I64) =>
            let suffix = if n != expected then " ERROR" else "" end
            env.out.print(name + ": " + fname + ": " + n.string() + suffix)
          })
      else
        env.err.print("unable to open " + fname)
        error
      end
    else
      env.err.print("unable to get ambient auth")
      error
    end
