Module: dylan-user
Synopsis: Library and module definitions for the merry-fxmas executable.

define library merry-fxmas-app
  use common-dylan;
  use merry-fxmas;
  use io,
    import: { standard-io, streams };
end library;

define module merry-fxmas-app
  use common-dylan;
  use standard-io;
  use streams;
  use merry-fxmas;
end module;
