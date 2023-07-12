module Rd = ReactDOMRe
module Rs = ReactDOMStyle

module D = struct
  external focus: Dom.element -> unit -> unit = "focus" [@@bs.send]
end

module H = struct
  let str = React.string
  let elems es = es |> Belt.List.toArray |> React.array
  let elp tag props children =
    ReactDOMRe.createDOMElementVariadic tag ~props (Array.of_list children)
  let elp' tag props children =
    ReactDOMRe.createDOMElementVariadic tag ~props:(props ReactDOMRe.domProps) (Array.of_list children)
  let el tag children =
    ReactDOMRe.createDOMElementVariadic tag (Array.of_list children)
  let elps tag props s =
    ReactDOMRe.createDOMElementVariadic tag ~props [|str s|]
  let els tag s =
    ReactDOMRe.createDOMElementVariadic tag [|str s|]
  let elpu tag props =
    ReactDOMRe.createDOMElementVariadic tag ~props [||]
  let elu tag =
    ReactDOMRe.createDOMElementVariadic tag [||]
end

module Ops = struct
  let (&) f x = f x
  let (&!) f x = f [x]
  let (%!) g f x = g [f x]
  let (>!) x f = f [x]
end
