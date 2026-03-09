(** Describes Open Graph cover elements. *)

(** {1 Structure} *)

(** The kind of cover element. *)
type kind =
  | Image
  | Video

(** A cover element. *)
type t

(** {2 Construction} *)

(** [make ~kind url] constructs a cover element. *)
val make
  :  kind:kind
  -> ?secure_url:Url.t
  -> ?mime_type:string
  -> ?dimension:int * int
  -> ?alt:string
  -> Url.t
  -> t

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t

(** {1 Enumerable} *)

module Set : Stdlib.Set.S with type elt = t
module Map : Stdlib.Map.S with type key = t

(** {1 Open Graph Related} *)

(** [to_open_graph cover] converts a cover element into Open Graph meta tags. *)
val to_open_graph : t -> Meta.t list
