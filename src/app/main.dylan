Module: merry-fxmas-app
Synopsis: Command-line entry point.

// The application layer chooses the destination; the library does not know
// about stdout at all. That separation is what makes the greetings testable:
// the test suite passes a string stream to the very same `write-greetings`.
define function main
    (name :: <string>, arguments :: <vector>) => ()
  write-greetings(*standard-output*);
  force-output(*standard-output*);
  exit-application(0);
end function;

// Calling our main function should be the last thing we do.
main(application-name(), application-arguments());
