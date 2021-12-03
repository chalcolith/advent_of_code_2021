use "files"

interface DayTask
  fun apply(lines: Iterator[String iso^], out: OutStream, err: OutStream): U32 ?

actor Main
  new create(env: Env) =>
    try
      run("D01P1e", "data/day_01_example.txt", Day01Part1, env)?
      run("D01P1", "data/day_01_data.txt", Day01Part1, env)?
      run("D01P2e", "data/day_01_example.txt", Day01Part2, env)?
      run("D01P2", "data/day_01_data.txt", Day01Part2, env)?
    else
      env.err.print("error!")
      env.exitcode(1)
    end

  fun run(name: String, fname: String, task: DayTask, env: Env) ? =>
    try

      let fpath = FilePath(env.root as AmbientAuth, fname)
      match OpenFile(fpath)
      | let file: File =>
        let result = task(FileLines(file), env.out, env.err)?
        env.out.print(name + ": " + fname + ": " + result.string())
      else
        env.err.print("unable to open " + fname)
        error
      end
    else
      env.err.print("unable to get ambient auth")
      error
    end
