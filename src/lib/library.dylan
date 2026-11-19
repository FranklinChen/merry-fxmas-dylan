Module: dylan-user
Synopsis: Library and module definitions for the merry-fxmas core library.

define library merry-fxmas
  use common-dylan;
  use io,
    import: { format, streams };

  // Only the interface module is exported. Exporting the implementation
  // module too would let any client reach into it, which would make the
  // "public API is exactly the create list below" claim false.
  export
    merry-fxmas;
end library;

// Interface module: the entire public API.
//
// Names are `create`d here and defined by the implementation module below, so
// a public name that nothing goes on to define is a compile error.
//
// `repeat-greeting` is public because the macro is the thing this project
// exists to demonstrate: a caller who wants a countdown of their own needs it.
define module merry-fxmas
  create
    <countdown>,
    greet,
    write-greetings,
    repeat-greeting;
end module;

// Implementation module. `use merry-fxmas` is how it declares that it supplies
// definitions for the names created above.
define module merry-fxmas-impl
  use common-dylan;
  use format;
  use streams;
  use merry-fxmas;
end module;
