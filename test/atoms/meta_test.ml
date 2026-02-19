open Codex_atoms
open Test_util

let%expect_test "make a simple meta tag" =
  Meta.make ~name:[ "og"; "title" ] "Hello"
  |> dump_opt (fun tag ->
    tag |> Meta.to_data |> Format.asprintf "%a" Yocaml.Data.pp);
  [%expect
    {|
    {"name": "og:title", "content": "Hello"}
    |}]
;;

let%expect_test "make_tag joins name segments with colon" =
  Meta.make_tag ~name:[ "twitter"; "card" ] "summary" |> dump_data Meta.to_data;
  [%expect
    {|
    {"name": "twitter:card", "content": "summary"}
    |}]
;;

let%expect_test "from maps a value through a function" =
  Meta.from
    ~name:[ "og"; "description" ]
    (fun s -> Some (String.uppercase_ascii s))
    "hello"
  |> dump_opt (fun tag ->
    tag |> Meta.to_data |> Format.asprintf "%a" Yocaml.Data.pp);
  [%expect
    {|
    {"name": "og:description", "content": "HELLO"}
    |}]
;;

let%expect_test "from_opt ignores None input" =
  Meta.from_opt ~name:[ "og"; "title" ] String.uppercase_ascii None
  |> dump_opt (fun tag ->
    tag |> Meta.to_data |> Format.asprintf "%a" Yocaml.Data.pp);
  [%expect {| |}]
;;

let%expect_test "from_opt maps Some value" =
  Meta.from_opt ~name:[ "og"; "title" ] String.uppercase_ascii (Some "hello")
  |> dump_opt (fun tag ->
    tag |> Meta.to_data |> Format.asprintf "%a" Yocaml.Data.pp);
  [%expect
    {|
    {"name": "og:title", "content": "HELLO"}
    |}]
;;

let%expect_test "from_value always produces a tag" =
  Meta.from_value ~name:[ "charset" ] string_of_int 8
  |> dump_opt (fun tag ->
    tag |> Meta.to_data |> Format.asprintf "%a" Yocaml.Data.pp);
  [%expect
    {|
    {"name": "charset", "content": "8"}
    |}]
;;

let%expect_test "to_data_list filters None values" =
  [ Meta.make ~name:[ "og"; "title" ] "Hello"
  ; None
  ; Meta.make ~name:[ "og"; "type" ] "website"
  ]
  |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:title", "content": "Hello"},
    {"name": "og:type", "content": "website"}]
    |}]
;;
