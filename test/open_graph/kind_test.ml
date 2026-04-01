open Codex_open_graph
open Codex_atoms
open Test_util

let published_time =
  Yocaml.Datetime.make ~time:(12, 0, 0) ~year:2024 ~month:1 ~day:1 ()
  |> Result.get_ok
;;

let updated_time =
  Yocaml.Datetime.make ~time:(9, 30, 0) ~year:2024 ~month:1 ~day:10 ()
  |> Result.get_ok
;;

let%expect_test "website kind produces og:type website" =
  Kind.website |> Kind.to_open_graph |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:type", "content": "website"}]
    |}]
;;

let%expect_test "article kind produces mandatory meta tags" =
  Kind.article ~published_time ~section:"Technology" ()
  |> Kind.to_open_graph
  |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:type", "content": "article"},
    {"name": "article:published_time", "content": "2024-01-01T12:00:00Z"},
    {"name": "article:section", "content": "Technology"}]
    |}]
;;

let%expect_test "article kind includes modified_time when provided" =
  Kind.article ~published_time ~updated_time ~section:"Technology" ()
  |> Kind.to_open_graph
  |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:type", "content": "article"},
    {"name": "article:published_time", "content": "2024-01-01T12:00:00Z"},
    {"name": "article:modified_time", "content": "2024-01-10T09:30:00Z"},
    {"name": "article:section", "content": "Technology"}]
    |}]
;;

let%expect_test "article kind emits one meta tag per article tag" =
  let tags = Tag.of_list [ "ocaml"; "opengraph" ] in
  Kind.article ~published_time ~section:"Technology" ~tags ()
  |> Kind.to_open_graph
  |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:type", "content": "article"},
    {"name": "article:published_time", "content": "2024-01-01T12:00:00Z"},
    {"name": "article:section", "content": "Technology"},
    {"name": "article:tag", "content": "ocaml"},
    {"name": "article:tag", "content": "opengraph"}]
    |}]
;;
