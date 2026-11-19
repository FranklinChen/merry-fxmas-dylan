Module: merry-fxmas-test-suite
Synopsis: Tests for the greeting countdown and the macro that generates it.

// How many greetings this suite expects `write-greetings` to emit.
//
// The library exports no count of its own: the literal token list inside
// `write-greetings` is the only source of truth. This constant is the
// suite's *independent* expectation, which is what gives the assertions
// below their value. Shortening the library's list without changing this
// number fails a test, which is exactly the drift we want caught.
define constant $expected-greeting-count = 25;

// Build the expected countdown without going through `format`.
//
// Deliberate: if the expectation were built with the same `format` call the
// implementation uses, a formatting bug would appear on both sides of the
// assertion and the test would pass anyway. `write` plus `integer-to-string`
// keeps the two independent. Writing into a stream also avoids the quadratic
// recopying that repeated `concatenate` into an accumulator would cost.
define function expected-countdown () => (output :: <string>)
  with-output-to-string (stream)
    for (n from $expected-greeting-count to 1 by -1)
      write(stream, "Merry Christmas Bill ");
      write(stream, integer-to-string(n));
      write(stream, "!\n");
    end for;
  end
end function;

define test test-greet-writes-one-greeting ()
  assert-equal("Merry Christmas Bill 25!\n",
               with-output-to-string (stream) greet(stream, 25) end);
  // A second position, so a greeting hardcoded to the head of the countdown
  // would not pass.
  assert-equal("Merry Christmas Bill 1!\n",
               with-output-to-string (stream) greet(stream, 1) end);
end test;

// The macro is documented to evaluate the stream expression exactly once, no
// matter how many greetings it expands to. This test counts evaluations with
// a closure and would fail if the recursion ever re-evaluated the expression
// per greeting instead of binding it once.
define test test-repeat-greeting-evaluates-stream-expression-once ()
  let evaluations = 0;
  let used-stream = #f;
  local method recording-stream () => (s :: <string-stream>)
          evaluations := evaluations + 1;
          let fresh = make(<string-stream>, direction: #"output");
          used-stream := fresh;
          fresh
        end method recording-stream;
  // Argument order forces the macro to see the closure, not a pre-evaluated
  // stream, which is the only way a caller could observe the count.
  repeat-greeting(recording-stream(), 1, 7, 4);
  assert-equal(1, evaluations);
  assert-equal("Merry Christmas Bill 1!\n"
                 "Merry Christmas Bill 7!\n"
                 "Merry Christmas Bill 4!\n",
               stream-contents(used-stream, clear-contents?: #f));
end test;

// The macro is the point of the project, so its expansion is tested directly
// at a size that is readable in a failure message rather than only through the
// 25-element production call.
//
// The list is deliberately unsorted: it proves in one assertion that multiple
// tokens expand, that they expand in argument order, and that the macro
// imposes no order of its own. A descending list such as 3, 2, 1 would not
// distinguish those.
define test test-repeat-greeting-expands-in-argument-order ()
  assert-equal("Merry Christmas Bill 1!\n"
                 "Merry Christmas Bill 7!\n"
                 "Merry Christmas Bill 4!\n",
               with-output-to-string (stream)
                 repeat-greeting(stream, 1, 7, 4)
               end);
end test;

// The single-token case exercises the recursion's base case, where the
// auxiliary rule matches once and then expands to nothing.
define test test-repeat-greeting-with-one-greeting ()
  assert-equal("Merry Christmas Bill 12!\n",
               with-output-to-string (stream)
                 repeat-greeting(stream, 12)
               end);
end test;

// Exact text, order, and length, all in one assertion. A separate line-count
// test would assert nothing this does not already imply.
define test test-write-greetings-matches-the-countdown ()
  assert-equal(expected-countdown(),
               with-output-to-string (stream) write-greetings(stream) end);
end test;

// Use `_build/bin/merry-fxmas-test-suite --help` to see options.
run-test-application()
