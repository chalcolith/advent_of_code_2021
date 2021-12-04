use k = "kiuatan"

// The result type of our grammar's semantic actions.

primitive Forward
primitive Down
primitive Up

type Direction is (Forward | Down | Up)

class val Command
  let direction: (Direction | None)
  let distance: I64

  new val create(direction': (Direction | None), distance': I64) =>
    direction = direction'
    distance = distance'

// Some handy aliases so we don't have to type out all the generic arguments.
type Parser is k.Parser[U8, None, Command]
type Success is k.Success[U8, None, Command]
type Failure is k.Failure[U8, None, Command]
type NamedRule is k.NamedRule[U8, None, Command]
type Conj is k.Conj[U8, None, Command]
type Disj is k.Disj[U8, None, Command]
type Star is k.Star[U8, None, Command]
type Literal is k.Literal[U8, None, Command]
type Single is k.Single[U8, None, Command]
type Bind is k.Bind[U8, None, Command]
type Variable is k.Variable

// Build grammar rules
class Day02Grammar
  var _command_line: (NamedRule | None) = None
  var _command: (NamedRule | None) = None
  var _number: (NamedRule | None) = None
  var _ws: (NamedRule | None) = None

  fun ref command_line(): NamedRule =>
    match _command_line
    | let r: NamedRule => r
    else
      let c = Variable
      let n = Variable

      let command_line' =
        recover val
          NamedRule("CommandLine",
            Conj([
              Bind(c, command())
              ws()
              Bind(n, number())
            ]),
            { (result, _, bindings) =>
              let direction: (Direction | None) =
                match try bindings(c)? end
                | (let success: Success, _) =>
                  let token = String
                  token.concat(success.start.values(success.next))
                  match token
                  | "forward" => Forward
                  | "down" => Down
                  | "up" => Up
                  end
                end

              let number: I64 =
                try
                  match bindings(n)?
                  | (let success: Success, _) =>
                    let digits = String
                    digits.concat(success.start.values(success.next))
                    (let num, _) = digits.read_int[I64]()?
                    num
                  end
                else
                  0
                end

              (Command(direction, number), bindings)
            })
        end
      _command_line = command_line'
      command_line'
    end

  fun ref command(): NamedRule =>
    match _command
    | let r: NamedRule => r
    else
      let command' =
        recover val
          NamedRule("Command",
            Disj([
              Literal("forward")
              Literal("down")
              Literal("up")
            ]))
        end
      _command = command'
      command'
    end

  fun ref number(): NamedRule =>
    match _number
    | let r: NamedRule => r
    else
      let number' =
        recover val
          NamedRule("Number", Star(Single("0123456789"), 1))
        end
      _number = number'
      number'
    end

  fun ref ws(): NamedRule =>
    match _ws
    | let r: NamedRule => r
    else
      let ws' = recover val NamedRule("WS", Star(Single(" \t"), 1)) end
      _ws = ws'
      ws'
    end
