(** Describes a full document (in the sense of Open graph). *)

(** The goal of the document is to be used when you generate an HTML
    document. It fill the common set of open-graph tags. *)

(** {1 Structure} *)

type t

(** [make ?locale ?cover ?kind ~title ~site_name ~url ()] produces the set
    of document-related-open-graph metadata. *)
val make
  :  ?locale:Codex_atoms.Language.t
  -> ?cover:Codex_atoms.Media.t
  -> kind:Kind.t
  -> title:string
  -> site_name:string
  -> url:Codex_atoms.Url.t
  -> unit
  -> t

(** [to_open_graph cover] converts a document into a set of Open Graph
    meta tags. *)
val to_open_graph : t -> Codex_atoms.Meta.t list
