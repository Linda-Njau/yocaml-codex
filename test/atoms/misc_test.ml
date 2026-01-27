open Test_util
open Codex_atoms

let%expect_test "merge record fields - 1" =
  let open Yocaml.Data in
  let a = record [ "a", int 1; "b", int 2 ] in
  let b = a |> Ext.Misc.merge_record_fields [] |> record in
  dump_data Fun.id b;
  [%expect {| {"a": 1, "b": 2} |}]
;;

let%expect_test "merge record fields - 2" =
  let open Yocaml.Data in
  let a = record [ "a", int 1; "b", int 2 ] in
  let b = a |> Ext.Misc.merge_record_fields [ "c", int 3 ] |> record in
  dump_data Fun.id b;
  [%expect {| {"c": 3, "a": 1, "b": 2} |}]
;;

let%expect_test "merge record fields - 3" =
  let open Yocaml.Data in
  let a = record [ "a", int 1; "b", int 2 ] in
  let b =
    a |> Ext.Misc.merge_record_fields ~key:"foo" [ "c", int 3 ] |> record
  in
  dump_data Fun.id b;
  [%expect {| {"foo": {"a": 1, "b": 2}, "c": 3} |}]
;;

let%expect_test "merge record fields - 4" =
  let open Yocaml.Data in
  let a = int 42 in
  let b =
    a |> Ext.Misc.merge_record_fields ~key:"foo" [ "c", int 3 ] |> record
  in
  dump_data Fun.id b;
  [%expect {| {"foo": 42, "c": 3} |}]
;;

let%expect_test "merge record fields - 5" =
  let open Yocaml.Data in
  let a = int 42 in
  let b = a |> Ext.Misc.merge_record_fields [ "c", int 3 ] |> record in
  dump_data Fun.id b;
  [%expect {| {"int": 42, "c": 3} |}]
;;
