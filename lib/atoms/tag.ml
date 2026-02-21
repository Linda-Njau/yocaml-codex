type t = string

let make s = String.trim s
let to_string s = s

let from_data =
  let open Yocaml.Data.Validation in
  string $ Stdlib.String.trim $ Ext.String.remove_leading_hash
  & String.not_blank
;;

let to_data t =
  let open Yocaml.Data in
  record [ "value", string t; "slug", t |> Yocaml.Slug.from |> string ]
;;

let equal a b = String.equal a b
let compare a b = String.compare a b

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

module Set = struct
  module S = Stdlib.Set.Make (Orderable)
  include S
  include Set.Make (S) (Orderable) (Orderable)
end

module Map = struct
  module S = Stdlib.Map.Make (Orderable)
  include S
  include Map.Make (S) (Orderable) (Orderable)
end

let of_list = List.fold_left (fun acc tag -> Set.add (make tag) acc) Set.empty
let set_to_string set = set |> Set.to_list |> String.concat ", "

let to_meta tags =
  if Set.is_empty tags
  then None
  else Meta.from_value ~name:[ "keywords" ] (fun s -> s |> set_to_string) tags
;;
