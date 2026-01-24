(** Describe a gender. *)

(** {1 Structure} *)

type t

(** {2 Projection}

    A Gender is projected as the following record:

    {eof@json[
      {
        "name": string,
        "has_pronouns": bool,
        "pronouns": {
           "has": bool,
           "all": List<string>,
           "repr": string
         }
      }
    ]eof}

    The field [repr] is a compact representation of the
    [pronouns]. For example, is the gender is associated to
    [["he"; "him"; "his"]], [repr] will be ["he/him/his"].

    {3 Example with Jingoo}

    {eof@html[
      <div>
        <span class="username">{{ user.display_name }}</span>
        {% if user.gender.has_pronouns %}
        <span class="nouns">({{ user.gender.pronouns.repr }})</span>
        {% endif %}
      </div>
    ]eof}

    {2 Validation}

    {@ocaml[
      open Codex_atoms
      open Codex_ontology

      let display_gender g =
        g |> Gender.to_data |> Format.asprintf "%a" Yocaml.Data.pp
      ;;

      let validate s =
        s
        |> Gender.from_data
        |> Result.map display_gender
        |> Result.iter print_endline
      ;;
    ]}

    The validation is pretty simple, you can just use a string :

    {@ocaml[
      # Yocaml.Data.(string "male") |> validate
      {"name": "male", "has_pronouns": true, "pronouns":
       {"has": true, "all": ["he", "him", "his"], "repr": "he/him/his"}}
      - : unit = ()
    ]} *)

(** {1 Building Genders} *)

val male : ?pronouns:string list -> unit -> t
val female : ?pronouns:string list -> unit -> t
val other : ?pronouns:string list -> string -> t

(** {1 Accessors} *)

val pronouns : t -> string list
val compare : t -> t -> int
val equal : t -> t -> bool

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t

(** {1 Enumerable} *)

module Set : sig
  include Stdlib.Set.S with type elt = t
  include Sigs.SET with type t := t
end

module Map : sig
  include Stdlib.Map.S with type key = t
  include Sigs.MAP with type 'a t := 'a t
end
