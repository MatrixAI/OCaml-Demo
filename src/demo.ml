open Core

(* This exports the Math module from math.ml, it makes Math a submodule *)
module Math = Math

let concatHello str = "Hello " ^ str ^ "!"

let greet subject =
  match subject with
  | None      -> "Hello World!"
  | Some name -> (concatHello name)
