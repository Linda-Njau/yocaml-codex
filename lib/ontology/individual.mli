(** An Individual is the smallest possible representation of a
    person's denotation. *)

(** {1 Structure} *)

type t

(** {1 Building Individuals} *)

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t
