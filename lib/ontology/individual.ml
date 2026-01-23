type t =
  { display_name : string
  ; first_name : string option
  ; last_name : string option
  }

let make ?first_name ?last_name display_name =
  { display_name; first_name; last_name }
;;

let to_data { display_name; first_name; last_name } =
  let open Yocaml.Data in
  let names = Ext.Option.zip first_name last_name in
  record
    [ "display_name", string display_name
    ; "first_name", option string first_name
    ; "last_name", option string last_name
    ; "has_first_name", bool @@ Ext.Option.to_bool first_name
    ; "has_last_name", bool @@ Ext.Option.to_bool last_name
    ; "has_names", bool @@ Ext.Option.to_bool names
    ; ( "with_names"
      , option
          (fun (first_name, last_name) ->
             (* Should be safe because of `as_name` that guards
                names of length > 1. *)
             let ff = first_name.[0] |> Ext.String.from_char
             and fl = last_name.[0] |> Ext.String.from_char in
             let initials = ff ^ fl |> String.lowercase_ascii
             and display =
               (ff |> String.uppercase_ascii) ^ ". " ^ last_name
               |> String.capitalize_ascii
             in
             record [ "initials", string initials; "display", string display ])
          names )
    ]
;;

let as_name =
  let open Yocaml.Data.Validation in
  string $ String.trim & String.not_blank & String.length_gt 1
;;

let from_triple = function
  | Some a, Some b, Some c -> Ok (a, Some b, Some c)
  | None, Some b, Some c ->
    let a = b ^ " " ^ c in
    Ok (a, Some b, Some c)
  | _ ->
    let error =
      Yocaml.Data.Validation.Missing_field { field = "display_name" }
      |> Yocaml.Nel.singleton
    in
    Error error
;;

let validate_name fields =
  let open Yocaml.Data.Validation in
  let+ display_name =
    opt
      fields
      "display_name"
      ~alt:
        [ "nick"
        ; "nickname"
        ; "user"
        ; "username"
        ; "displayname"
        ; "name"
        ; "designation"
        ; "denotation"
        ; "alias"
        ; "aka"
        ; "cognomen"
        ; "handle"
        ; "dname"
        ]
      as_name
  and+ first_name =
    opt
      fields
      "first_name"
      ~alt:
        [ "given_name"; "firstname"; "forename"; "fname"; "givenname"; "gname" ]
      as_name
  and+ last_name =
    opt fields "last_name" ~alt:[ "lastname"; "lname" ] as_name
  in
  display_name, first_name, last_name
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ display_name, first_name, last_name =
      (validate_name & from_triple) fields
    in
    make ?first_name ?last_name display_name)
;;

let from_data = from_record
