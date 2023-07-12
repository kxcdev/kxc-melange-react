(lang dune 3.9)
(using directory-targets 0.1)
(using melange 0.1)
(name kxc-melange-react-ppx)

(license Apache-2.0)
(maintainers
  "Haochen Kotoi-Xie <hx@kxc.inc>"
  "KXC Members <info@kxc.inc>")
(authors
  "Haochen Kotoi-Xie"
  "KXC Members and Contributors")

(source
 (github kxcdev/kxc-melange-react-ppx))

(generate_opam_files true)
(package
 (name kxc-melange-react-ppx)
 (synopsis "PPX to streamline melange projects that use React.js in the OCaml systax")
 (depends
  (melange (and (>= 1.0.0) (< 2.0.0)))
  (ppxlib (>= 0.26))
  (odoc (and :with-doc (>= 2.1.0)))
  (alcotest :with-test)
  (qcheck :with-test)
  (ocamlformat (and :with-test (>= 0.25.1)))
  (ocaml (>= 4.14))))
