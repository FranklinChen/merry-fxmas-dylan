module: dylan-user

define library merry-fxmas
  use common-dylan;
  use io;
end library;

define module merry-fxmas
  use common-dylan, exclude: { format-to-string };
  use format-out;
end module;
