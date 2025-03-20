#import "@preview/polylux:0.4.0"
#import "colors.typ": *
#import "../../utils.typ": *

#let uncover = polylux.uncover
#let only = polylux.only
#let later = polylux.later
#let slide(..args) = {
  state("etiennecollin-slides", ()).update(k => {
    k.push("normal")
    k
  })

  polylux.slide(..args)
}

#let focus-slide(body) = {
  set page(fill: purple)
  set text(fill: white)

  state("etiennecollin-slides", ()).update(k => {
    k.push("focus")
    k
  })

  polylux.slide[
    #set text(size: 1.5em, weight: "bold")
    #show: align.with(center + horizon)
    #v(-0.75em)
    #body
  ]
}

#let slides(
  title: none,
  subtitle: none,
  footer: none,
  author: none,
  email: none,
  semester: none,
  date: none,
  page-numbering: (n, total) => {
    text(size: 0.75em, strong[#n.first()])
    text(size: 0.5em, [ \/ #total.first()])
  },
  show-subtitle-slide: true,
  show-author: true,
  show-outline: true,
  show-footer: true,
  show-page-numbers: true,
  lang: "en",
  outline-text: "Outline",
  font: "Atkinson Hyperlegible",
  header-font: "Atkinson Hyperlegible",
  body,
) = {
  let left-footer = if footer != none {
    footer
  } else {
    text(
      size: 0.5em,
      (
        if semester != none [#semester],
        [#title],
        subtitle,
        if show-author { author },
      )
        .filter(e => e != none)
        .join[ --- ],
    )
  }

  show footnote.entry: set text(size: 0.5em)
  set quote(block: true, quotes: true)
  show link: underline
  show heading: set text(fill: purple, font: header-font)
  set text(size: 24pt, font: font, lang: lang)
  set page(
    paper: "presentation-16-9",
    footer: {
      let fs = state("etiennecollin-slides", ())

      (
        context if show-footer
          and (not show-subtitle-slide or here().page() > 1) {
          set text(
            fill: if fs.at(here()).last() != none
              and fs.at(here()).last() == "normal" {
              purple.lighten(25%)
            } else {
              blue.lighten(25%)
            },
          )

          left-footer

          h(1fr)

          if show-page-numbers {
            page-numbering(counter(page).at(here()), counter(page).final())
          }
        }
      )
    },
  )

  if show-subtitle-slide {
    slide(
      align(
        horizon,
        [
          #block(inset: (left: 1cm, top: 3cm))[
            #text(
              font: header-font,
              fill: purple,
              size: 2em,
              strong[#title ],
            ) \
            //
            #text(
              fill: purple.lighten(25%),
              font: header-font,
              strong(subtitle),
            )

            #set text(size: 0.75em)
            #if show-author [#author #if email != none [--- #email ] \ ]
            #if semester != none [#semester\ ]
            #if date != none [#date]
          ]
        ],
      ),
    )
  }

  if show-outline {
    set page(
      fill: purple,
      footer: context if show-footer {
        set text(
          fill: if here().page() > 2 or not show-outline {
            purple.lighten(25%)
          } else {
            blue.lighten(25%)
          },
        )

        left-footer
      },
    )

    slide[
      #set text(fill: white)

      #heading(
        outlined: false,
        text(fill: blue.lighten(25%), outline-text),
      )
      #outline(indent: auto, depth: 1, title: none)
    ]
  }

  counter(page).update(1)

  set page(fill: white)
  body
}

