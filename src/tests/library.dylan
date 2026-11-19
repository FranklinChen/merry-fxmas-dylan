Module: dylan-user
Synopsis: Library and module definitions for the merry-fxmas test suite.

define library merry-fxmas-test-suite
  use common-dylan;
  use testworks;
  use merry-fxmas;
  use io,
    import: { streams };
end library;

define module merry-fxmas-test-suite
  use common-dylan;
  use testworks;
  use streams;
  // Everything the suite needs, including the macro, is public API.
  use merry-fxmas;
end module;
