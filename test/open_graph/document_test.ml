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

let%expect_test "create a document" =
  let kind =
    Kind.article
      ~authors:Url.(Set.of_list [ https "xvw.lol"; https "gr-im.github.io" ])
      ~published_time
      ~section:"articles"
      ()
  in
  let doc =
    Document.make
      ~kind
      ~title:"My page"
      ~site_name:"xvw"
      ~url:Url.(https "xvw.lol")
      ()
  in
  doc |> Document.to_open_graph |> dump_data Meta.to_data_list;
  [%expect {|
    [{"name": "og:title", "content": "My page"},
    {"name": "og:site_name", "content": "xvw"},
    {"name": "og:url", "content": "https://xvw.lol"},
    {"name": "og:type", "content": "article"},
    {"name": "article:published_time", "content": "2024-01-01T12:00:00Z"},
    {"name": "article:section", "content": "articles"},
    {"name": "article:author", "content": "https://gr-im.github.io"},
    {"name": "article:author", "content": "https://xvw.lol"}]
    |}]
;;
