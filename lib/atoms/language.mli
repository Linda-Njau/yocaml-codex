(** Describes a natural language, optionally scoped to a region.

    Language values are normalized and validated using the {!Iso639} library *)

(** {1 Structure} *)

type t

(** {2 Projection}

    A language is projected as the following record:

    {eof@json[
      {
        "tag": string,
        "code": string,
        "iso639p1": Option<string>,
        "iso639p2": Option<string>,
        "scope": string,
        "is_macro": bool,
        "region": Option<string>,
        "has_region": bool
      }
    ]eof} *)

(** {2 Validation}

    Languages can be validated from strings (for example ["en"], ["en-US"],
    or canonical names such as ["english"]), or from records containing
    language and optional region fields. *)

(** {1 Manipulating Languages} *)

(** [to_string lang] renders the language as a string
    (for example ["en"] or ["en-KE"]). *)
val to_string : t -> string

(** [compare a b] compare two languages. *)
val compare : t -> t -> int

(** [equal a b] equality between two languages. *)
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
