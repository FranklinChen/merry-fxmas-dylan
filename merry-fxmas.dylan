module: merry-fxmas
synopsis: Demonstrate Dylan macro to say Merry Christmas
author: Franklin Chen
copyright: (c) 2012 Franklin Chen

// Simple example of a syntactic macro
define macro repeat-greeting
  { repeat-greeting() }
    => { }
  { repeat-greeting(?n:token ...) }
    => { format-out("Merry Christmas Bill %D!\n", ?n);
         repeat-greeting(...) }
end macro;

define function main (name :: <string>, arguments :: <vector>)
  repeat-greeting(25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1);
  exit-application(0);
end function main;

main(application-name(), application-arguments());
