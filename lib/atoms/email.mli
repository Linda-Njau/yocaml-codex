(** Describes Email Adress, based of
    {{:https://ocaml.org/p/emile/latest} Emile library}. *)

(** {1 Structure} *)

type t

(** [to_string addr] render te [addr] as a [string]. *)
val to_string : t -> string

(** [compare a b] compare two emails. *)
val compare : t -> t -> int

(** [equal a b] equality between two emails. *)
val equal : t -> t -> bool

(** Validation extracting a name and an email. *)
val from_mailbox : (string, string * t) Yocaml.Data.validator

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
