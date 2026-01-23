(** Describe a gender. *)

(** {1 Structure} *)

type t

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
