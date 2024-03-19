// =============================================================================
// Document setup
// =============================================================================
#let article(
  title: none, subtitle: none, abstract: none, authors: none, class: none, institution: none, duedate: none, logo: none, bib: none, bibstyle: "ieee", toc: false, titlepage: false, showdate: false, cols: 1, indent-first-line: true, margin: (x: 1in, y: 1in), paper: "us-letter", lang: "en", region: "CA", fonts: (), fontsize: 12pt, sectionnumbering: "1.1.a", doc,
) = {
  // ==========================================================================
  // Setup language settings
  // ==========================================================================
  let numbering = "1/1"
  let abstract_name = "Abstract"
  let bib_name = "References"
  if lang == "en" {
    numbering = "1 of 1"
    abstract_name = "Abstract"
    bib_name = "References"
  } else if lang == "fr" {
    numbering = "1 sur 1"
    abstract_name = "Résumé"
    bib_name = "Bibliographie"
  }

  // ===========================================================================
  // Setup components
  // ===========================================================================
  show par: set block(spacing: if indent-first-line { 0.65em } else { 1em })
  set par(
    justify: true, first-line-indent: if indent-first-line { 1.5em } else { 0em },
  )
  set text(lang: lang, region: region, font: fonts, size: fontsize)
  set heading(numbering: sectionnumbering)

  // ===========================================================================
  // Utils
  // ===========================================================================
  // Properly formatthe path to a file
  let get_correct_path(text_path) = { return text_path.replace("\~", "~").replace("\_", "_") }

  // Convert content to string by recursively traversing the
  // content tree and merging children
  let to-string(content) = {
    if content.has("text") {
      content.text
    } else if content.has("children") {
      content.children.map(to-string).join("")
    } else if content.has("body") {
      to-string(content.body)
    } else if content == [ ] {
      " "
    }
  }

  // ===========================================================================
  // Setup page
  // ===========================================================================
  let ht-first = state("page-first-section", [])
  let ht-last = state("page-last-section", [])
  set page(
    paper: paper, margin: margin, header: context[
      #if counter(page).get().first() > 1 [
        #let left_content = if showdate { [#datetime.today().display("[year]/[month]/[day]")] } else { none }

        #grid(
          columns: (1fr, 1fr, 1fr), inset: 0.5em, align(left, left_content), align(center, title), align(right, [#authors.at(0).name | #authors.at(0).id]), grid.hline(),
        )
      ]
    ], footer: context[
      #if counter(page).get().first() > 1 [
        #let left_content = if class.instructor != none { align(left)[#class.instructor] } else { none }
        #let center_content = counter(page).display(numbering, both: true)

        #let right_content = locate(
          loc => [
            // Find first heading of level 1 on current page
            #let first-heading = query(heading.where(level: 1), loc).find(h => h.location().page() == loc.page())
            // Find last heading of level 1 from the current page
            #let last-heading = query(heading.where(level: 1), loc).rev().find(h => h.location().page() == loc.page())
            // Check if there is a new heading on the current page
            #{
              if not first-heading == none {
                ht-first.update(
                  [ #counter(heading).at(first-heading.location()).at(0): #first-heading.body ],
                )
                ht-last.update(
                  [ #counter(heading).at(last-heading.location()).at(0): #last-heading.body ],
                )
                align(right, text(luma(25%), style: "italic")[Section #ht-first.display()])
              } else {
                align(right, text(luma(25%), style: "italic")[Section #ht-last.display()])
              }
            }
          ],
        )

        #grid(
          columns: (1fr, 1fr, 1fr), inset: 0.5em, grid.hline(), align(left, left_content), align(center, center_content), align(right, right_content),
        )
      ]
    ],
  )

  // ===========================================================================
  // Setup header with title page
  // ===========================================================================
  if titlepage {
    v(1fr)

    align(center)[
      #if title != none {
        smallcaps(text(size: 1.7em)[#title])
        linebreak()
      }
      #if subtitle != none {
        smallcaps(text(size: 1.45em)[#subtitle])
        linebreak()
      }
      #if class.number != none and class.name != none {
        smallcaps(text(size: 1.45em)[#class.name - #class.number])
      } else {
        if class.number != none {
          smallcaps(text(size: 1.45em)[#class.number])
        } else if class.name != none {
          smallcaps(text(size: 1.45em)[#class.name])
        }
      }
    ]

    v(1fr)

    if authors != none {
      let count = authors.len()
      let ncols = calc.min(count, 2)
      v(2em)
      grid(
        columns: (1fr,) * ncols, row-gutter: 1.7em, ..authors.map(author => align(center)[
          #smallcaps(text(size: 1.45em)[#author.name]) \
          #smallcaps(text(size: 1.1em)[#author.affiliation]) \
          #smallcaps(text(size: 1.1em)[#author.email])
        ]),
      )
      v(2em)
    }

    v(1fr)

    align(center)[
      #v(1em)
      #if class != none {
        smallcaps(text(size: 1.2em)[Section #class.section])
        linebreak()
      }
      #if class.instructor != none {
        smallcaps(text(size: 1.2em)[#class.instructor])
      }

      #v(1em)

      #if institution != none {
        smallcaps(text(size: 1.2em)[#institution])
        linebreak()
      }
      #if class.semester != none {
        text(size: 1.2em)[#class.semester]
        linebreak()
      }
      #if duedate != none {
        text(size: 0.9em)[#duedate]
      }

      #v(1fr)

      #if logo != none {
        let correct_path = get_correct_path([#logo].text)

        block(inset: 1em)[
          #image(correct_path, width: 80%)
        ]
      }
    ]

    v(1fr)
    pagebreak()
    counter(page).update(1)
    // =========================================================================
    // Setup header without title page
    // =========================================================================
  } else {
    align(center)[
      #if title != none {
        smallcaps(text(size: 1.7em)[#title])
        linebreak()
      }
      #if subtitle != none {
        smallcaps(text(size: 1.45em)[#subtitle])
        linebreak()
      }
      #if class.number != none and class.name != none {
        smallcaps(text(size: 1.45em)[#class.name - #class.number])
      } else {
        if class.number != none {
          smallcaps(text(size: 1.45em)[#class.number])
        } else if class.name != none {
          smallcaps(text(size: 1.45em)[#class.name])
        }
      }
    ]

    if authors != none {
      let count = authors.len()
      let ncols = calc.min(count, 2)
      block(
        inset: 0.5em,
      )[
        #grid(
          columns: (1fr,) * ncols, row-gutter: 1.7em, ..authors.map(author => align(center)[
            #smallcaps(text(size: 1.45em)[#author.name]) \
            #smallcaps(text(size: 1.1em)[#author.affiliation]) \
            #smallcaps(text(size: 1.1em)[#author.email])
          ]),
        )
      ]
    }

    align(center)[
      #if class != none {
        smallcaps(text(size: 1.2em)[Section #class.section])
        linebreak()
      }
      #if class.instructor != none {
        smallcaps(text(size: 1.2em)[#class.instructor])
      }

      #if institution != none {
        smallcaps(text(size: 1.2em)[#institution])
        linebreak()
      }
      #if class.semester != none {
        text(size: 1.2em)[#class.semester]
        linebreak()
      }
      #if duedate != none {
        text(size: 0.9em)[#duedate]
      }
    ]
  }

  // ===========================================================================
  // Setup abstract
  // ===========================================================================
  if abstract != none {
    block(inset: 2em)[
      #text(weight: "semibold")[#abstract_name]
      #h(1em)
      #eval(to-string[#abstract], mode: "markup")
    ]
    if titlepage or not toc {
      pagebreak()
    }
  }

  // ===========================================================================
  // Setup toc
  // ===========================================================================
  if toc {
    block(above: 0em, below: 2em)[
      #outline(title: auto, depth: none)
    ]
    pagebreak()
  }

  // ===========================================================================
  // Setup columns
  // ===========================================================================
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }

  if bib != none {
    pagebreak()
    bibliography(bib, title: bib_name, style: bibstyle)
  }
}

// =============================================================================
// Custom functions
// =============================================================================
#let box-colors = (
  default: (stroke: luma(70), fill: white, title: white), red: (stroke: rgb(237, 32, 84), fill: rgb(253, 228, 224), title: white), green: (stroke: rgb(102, 174, 62), fill: rgb(235, 244, 222), title: white), blue: (stroke: rgb(29, 144, 208), fill: rgb(232, 246, 253), title: white),
)

#let colorbox(title: none, color: "default", radius: 2pt, width: auto, body) = {
  return block(
    fill: box-colors.at(color).fill, stroke: 2pt + box-colors.at(color).stroke, radius: radius, width: width,
  )[
    #if title != none [
      #block(
        fill: box-colors.at(color).stroke, inset: 8pt, radius: (top-left: radius, bottom-right: radius),
      )[
        #text(fill: box-colors.at(color).title, weight: "bold")[#title]
      ]
    ]

    #block(
      width: 100%, inset: (x: 8pt, bottom: 8pt, top: if title == none { 8pt } else { 0pt }),
    )[
      #body
    ]
  ]
}
