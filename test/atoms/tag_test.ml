open Codex_atoms
open Test_util

let%expect_test "validate a tag from string" =
  Yocaml.Data.string "food" |> Tag.from_data |> dump_validation Tag.to_data;
  [%expect {| [V]	{"value": "food", "slug": "food"} |}]
;;

let%expect_test "validate a tag trims whitespace" =
  Yocaml.Data.string "  Machine Learning  "
  |> Tag.from_data
  |> dump_validation Tag.to_data;
  [%expect {| [V]	{"value": "Machine Learning", "slug": "machine-learning"} |}]
;;

let%expect_test "validate a tag removes leading hash" =
  Yocaml.Data.string "#AI" |> Tag.from_data |> dump_validation Tag.to_data;
  [%expect {| [V]	{"value": "AI", "slug": "ai"} |}]
;;

let%expect_test "reject empty tag" =
  Yocaml.Data.string "" |> Tag.from_data |> dump_validation Tag.to_data;
  [%expect
    {|
    [X]	--- Oh dear, an error has occurred ---
    Validation error:
    Entity: `test`

    Message:
      Message: should not be blank
      Given: ``---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;

let%expect_test "reject blank tag" =
  Yocaml.Data.string "   " |> Tag.from_data |> dump_validation Tag.to_data;
  [%expect
    {|
    [X]	--- Oh dear, an error has occurred ---
    Validation error:
    Entity: `test`

    Message:
      Message: should not be blank
      Given: ``---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;

let%expect_test "build a tag set from list" =
  [ "food"; "fitness"; "food"; "fitness" ]
  |> Tag.of_list
  |> Tag.Set.to_list
  |> List.map Tag.to_string
  |> dump_data (Yocaml.Data.list_of Yocaml.Data.string);
  [%expect
    {|
    ["fitness", "food"]
    |}]
;;

let%expect_test "project tag set to meta keywords" =
  [ "food"; "fitness" ]
  |> Tag.of_list
  |> Tag.to_meta
  |> Option.iter (dump_data Meta.to_data);
  [%expect
    {|
    {"name": "keywords", "content": "fitness, food"}
    |}]
;;

let%expect_test "empty tag set produces no meta tag" =
  Tag.Set.empty |> Tag.to_meta |> Option.iter (dump_data Meta.to_data);
  [%expect {| |}]
;;
