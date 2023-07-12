open Kxc_melange_react
open Kxc_melange_react.Ops
open Kxclib_melange

module Chakra = struct
  external provider : ?children:React.element -> unit -> React.element = "ChakraProvider"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external stack :
    ?spacing:string
    -> ?children:React.element
    -> unit -> React.element = "Stack"
  [@@bs.module "@chakra-ui/react"][@@react.component]
  external hstack :
    ?spacing:string
    -> ?children:React.element
    -> unit -> React.element = "HStack"
  [@@bs.module "@chakra-ui/react"][@@react.component]
  external vstack :
    ?spacing:string
    -> ?children:React.element
    -> unit -> React.element = "VStack"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external box : ?children:React.element -> unit -> React.element = "Box"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external container : ?children:React.element -> unit -> React.element = "Container"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external divider :
    ?orientation:[`vertical|`horizontal]
    -> unit -> React.element = "Divider"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external wrap : ?children:React.element -> unit -> React.element = "Wrap"
  [@@bs.module "@chakra-ui/react"][@@react.component]
  external wrap_item : ?children:React.element -> unit -> React.element = "WrapItem"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  let wrapped es = (es |&> fun e -> wrap_item [e]) |> wrap

  external spinner : ?size:string -> ?color:string -> unit -> React.element = "Spinner"
  [@@bs.module "@chakra-ui/react"][@@react.component]
  external avatar : ?name:string -> ?src:string -> unit -> React.element = "Avatar"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external radio :
    ?value:string
    -> ?defaultChecked:bool
    -> ?isDisabled:bool
    -> ?children:React.element
    -> unit -> React.element = "Radio"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external radio_group :
    ?children:React.element
    -> ?defaultValue:string
    -> ?onChange:(string -> unit)
    -> unit -> React.element = "RadioGroup"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external heading :
    ?size:[`xs | `sm | `md | `lg]
    -> ?children:React.element
    -> unit -> React.element = "Heading"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external text :
    ?fontSize:[ `xs | `sm | `md | `lg | `xl ]
    -> ?children:React.element
    -> unit -> React.element = "Text"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external button :
    ?fontSize:[ `xs | `sm | `md | `lg ]
    -> ?colorScheme:string
    -> ?onClick:(_ -> unit)
    -> ?variant:[`ghost | `outline | `solid | `link | `unstyled]
    -> ?children:React.element
    -> unit -> React.element = "Button"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external progress :
    ?isIndeterminate:bool
    -> ?size:string
    -> ?height:string
    -> ?colorScheme:string
    -> unit -> React.element = "Progress"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  external alert_container :
    ?status:[`info | `warning | `success | `error | `loading ]
    -> ?children:React.element
    -> unit -> React.element = "Alert"
  [@@bs.module "@chakra-ui/react"][@@react.component]
  external alert_icon :
    unit -> React.element = "AlertIcon"
  [@@bs.module "@chakra-ui/react"][@@react.component]
  let alert ?status children = alert_container ?status ((alert_icon()) :: children)

  external pin_input_container :
    ?value:string
    -> ?manageFocus:bool
    -> ?_type:[`alphanumeric|`number]
    -> ?mask:bool
    -> ?autoFocus:bool
    -> ?onChange:(string -> unit)
    -> ?onComplete:(string -> unit)
    -> ?children:React.element
    -> unit -> React.element = "PinInput"
  [@@bs.module "@chakra-ui/react"][@@react.component]
  external pin_input_field : unit -> React.element = "PinInputField"
  [@@bs.module "@chakra-ui/react"][@@react.component]

  let pin_input ?ref ?value ?autoFocus ?manageFocus ?_type ?mask ?onChange ?onComplete n =
    iotaf (fun i ->
        let ref = if i = 0 then ref else None in
        pin_input_field ?ref ()) n
    |> pin_input_container ?value ?autoFocus ?manageFocus ?_type?onChange ?onComplete ?mask
end

let candidates =
  let icon8 = sprintf "https://img.icons8.com/?size=512&id=%s&format=png" in
  [
    ("apple", icon8 "s3EqD09UVwX5", "green",
     "An uncut apple");

    ("torii", icon8 "Azb3I7VKwMUm", "red",
     "A red man-made architectural artifact");

    ("edible-leg", icon8 "2snCL7YDgvC3", "purple",
     "A cooked part of animal body");
  ]

let[@react.component] app () =
(* let app () = *)
  let open Chakra in
  let map_color =
    let map =
      candidates |&> (fun (id, _, scheme, _) -> id, scheme)
      |> List.to_seq |> StringMap.of_seq in
    fun id -> StringMap.find_opt id map in
  let colorScheme, set_color_scheme = React.useState (constant None) in
  let pin_value, set_pin_value = React.useState (constant "") in
  let set_pin_value s = set_pin_value (constant s) in
  let bingo, should_check, pin_expected_length =
    let expected = "1234" in
    let expected_length = String.length expected in
    pin_value = expected,
    String.length pin_value = expected_length,
    expected_length in
  let pin_input_ref = React.useRef Js.Nullable.null in
  [ heading ~size:`lg &! H.str "example/chakra-simple";

    text &! H.str (sprintf "This is an example (name=%s) for OCaml, melange and React.js" __FILE__);

    radio_group
      ~onChange:(fun c ->
        info "%S selected => colorScheme ~> %a" c Option.(pp pp_string) (map_color c);
        set_color_scheme (constant (map_color c)))
    &!
    (candidates |&> (fun (id, icon, _, desc) ->
       radio
         ~value:id
       &! hstack [
         avatar() ~name:id ~src:icon;
         H.str desc >! box;
        ]
     ) |> stack);

    divider();

    stack & [
      hstack & [
        heading ~size:`xs &! H.str "PIN:";
        pin_input pin_expected_length
          ~ref:(ReactDOM.Ref.domRef pin_input_ref)
          ~autoFocus:true
          ~value:pin_value
          ~onChange:set_pin_value
          ~onComplete:(fun s ->
            info "pin: %s" s;
            set_pin_value s);
        button [H.str "(clear)"]
          ?colorScheme
          ~variant:`outline
          ~onClick:(fun () ->
            set_pin_value "";
            Js.Nullable.iter
              pin_input_ref.current
              (fun[@bs] x -> D.focus x ());
            info "clear pin, focus on pin input"
          );
      ];
     ] @ (
      if bingo
      then [alert ~status:`success &! H.str "Bingo!"]
      else if should_check then [alert ~status:`error &! H.str "Wrong pin! (try 1234)"]
      else []);
  ] |> (fun body ->
    Chakra.provider [
        progress ~isIndeterminate:true ~height:"4px" ?colorScheme ();
        stack body >! container;
  ])

let () =
  ReactDOM.querySelector "#root"
  |> function
    | Some root ->
       ReactDOM.render (app()) root
    | None ->
       Js.Console.error "Failed to start React: couldn't find the #root element";
       failwith "bad"
