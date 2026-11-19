Module: merry-fxmas-impl
Synopsis: A recursive syntactic macro that expands to a countdown of greetings.
Author: Franklin Chen
Copyright: (c) 2012-2026 Franklin Chen

// A greeting's position in the countdown.
//
// Positions start at 1, so zero and negative positions are not merely
// discouraged, they cannot be constructed. `greet` therefore needs no
// range check and no caller can forget to make one.
define constant <countdown> = limited(<integer>, min: 1);

// Write a single greeting to `stream`.
//
// Every greeting in the library funnels through this one function, so the
// countdown-position invariant is enforced in exactly one place rather than
// once per call site.
define function greet
    (stream :: <stream>, n :: <countdown>) => ()
  format(stream, "Merry Christmas Bill %d!\n", n);
end function;

// The demonstration piece: a recursive syntactic macro.
//
// The main rule evaluates the stream expression exactly once and binds it to
// `greeting-stream`; the `greetings` auxiliary rule set then consumes one
// token per recursive step.
//
// `greeting-stream` is a plain identifier rather than a pattern variable
// because auxiliary rules cannot see the main rule's pattern variables. That
// is the one thing to understand before editing this macro, and it is
// explained in full, with the upstream precedent, in the README.
define macro repeat-greeting
  { repeat-greeting(?stream:expression, ?greetings) }
    => { begin
           let greeting-stream = ?stream;
           ?greetings
         end }

greetings:
  { }
    => { }
  { ?n:token, ... }
    => { greet(greeting-stream, ?n); ... }
end macro;

// Write the traditional countdown, descending to 1.
//
// The literal token list below is the macro's input and is expanded at compile
// time into that many straight-line `greet` calls; there is no loop here.
//
// That list is the single source of truth for how many greetings there are.
// The library deliberately exports no `$greeting-count` constant: a hand
// written count sitting beside a hand written list is two encodings of one
// fact that nothing keeps in agreement. The test suite states its own expected
// count instead, so a change to this list fails a test rather than silently
// contradicting a constant.
define function write-greetings (stream :: <stream>) => ()
  repeat-greeting(stream,
                  25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
                  12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1);
end function;
