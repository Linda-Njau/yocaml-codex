(** Describes HTML meta tags emitted in the final document head. *)

(** {1 Structure} *)

(** A concrete HTML meta tag. *)
type tag

(** The type used to compose meta tags.

    Meta tags are optional so they can be conditionally emitted. *)
type t = tag option

(** {2 Construction} *)

(** [make_tag ~name content] constructs a concrete meta tag. *)
val make_tag : name:string list -> string -> tag

(** [make ~name content] constructs a present meta tag. *)
val make : name:string list -> string -> t

(** [from ~name f x] constructs a meta tag by applying [f] to [x]. *)
val from : name:string list -> ('a -> string option) -> 'a -> t

(** [from_opt ~name f x] constructs a meta tag from an optional value. *)
val from_opt : name:string list -> ('a -> string) -> 'a option -> t

(** [from_value ~name f x] constructs a meta tag from a value. *)
val from_value : name:string list -> ('a -> string) -> 'a -> t

(** {2 Projection} *)

(** A meta tag is projected as the following record:

    {eof@json[
      {
        "name": string,
        "content": string
      }
    ]eof}

    {3 Example with Jingoo}

    {eof@html[
      {% for meta in metas %}
        <meta name="{{ meta.name }}" content="{{ meta.content }}">
      {% endfor %}
    ]eof} *)

(** {1 YOCaml Related} *)

(** [to_data tag] converts a meta tag into [Yocaml.Data.t] for template rendering.
*)
val to_data : tag -> Yocaml.Data.t

(** [to_data_list tags] converts a list of meta tags into [Yocaml.Data.t]. *)
val to_data_list : t list -> Yocaml.Data.t
