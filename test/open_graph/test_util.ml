let dump_data f x =
  x |> f |> Format.asprintf "%a" Yocaml.Data.pp |> print_endline
;;
