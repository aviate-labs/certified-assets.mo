let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.10.2-20231113/package-set.dhall sha256:6ce0f76863d2e6c8872a59bf5480b71281eb0e3af14c2bda7a1f34af556abab2
let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let
  -- This is where you can add your own packages to the package-set
  additions =
    [
      { name = "http"
      , version = "v0.1.2"
      , repo = "https://github.com/aviate-labs/http.mo"
      , dependencies = [] : List Text
      }
    ] : List Package

let
  {- This is where you can override existing packages in the package-set

     For example, if you wanted to use version `v2.0.0` of the foo library:
     let overrides = [
         { name = "foo"
         , version = "v2.0.0"
         , repo = "https://github.com/bar/foo"
         , dependencies = [] : List Text
         }
     ]
  -}
  overrides =
    [] : List Package

in  upstream # additions # overrides
