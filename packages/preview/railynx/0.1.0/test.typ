#import "railynx.typ": railynx

= Usage

== Basic

#railynx(2, ("1e 2e", "1sr 2sl", ""))

== Complex

#railynx(
  3,
  ("0e 2e 0adl 2aur", "2sl", "0pl 1Pr 0adr 1arl 2arr", "0Sr", "1sr 1E 2aur"),
  baseIndex: 0,
  railSpace: 0.8cm,
  nodeSpace: 1.2cm,
  breakable: false,
  fill: gray,
  stroke: black,
  railStroke: 1pt + white,
  switchTension: 0.4,
  platformFill: aqua,
  arrowDx: 0.25,
  arrowFill: orange,
  arrowStroke: yellow,
)

= Error Handling

== Argument Type

=== `rails`

#railynx("1", "1e")

=== `nodes`

#railynx(1, 1)

=== element(s) of `nodes`

#railynx(1, (1, 2))

== Index out of bounds

=== Operation Character

#railynx(1, ("1e", "1s"))

=== Operation Index

#railynx(1, "1e 2e")

=== Switch Operation Index

#railynx(1, ("1e", "1sr"))
