(** Describes a full document (in the sense of Open graph). *)

(** {1 Structure} *)

type t

val make
  :  ?locale:Codex_atoms.Language.t
  -> ?cover:Codex_atoms.Media.t
  -> Kind.t
  -> string
  -> string
  -> Codex_atoms.Url.t
  -> t

val to_open_graph : t -> Codex_atoms.Meta.t list
