let greet subject =
  match subject with
  | None      -> "Hello World!"
  | Some name -> "Hello " ^ name ^ "!"

let () = Printf.printf "%s\n" @@ greet (Some "Dragonkai")
