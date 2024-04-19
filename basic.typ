#import "packages.typ": *
#import "utils.typ": *

// =============================================================================
// Document setup
// =============================================================================
#let article(
  title: none, subtitle: none, abstract: none, authors: none, class: none, institution: none, duedate: none, logo: none, bib: none, bibstyle: "ieee", toc: false, titlepage: false, showdate: false, cols: 1, indent-first-line: true, margin: (x: 1in, y: 1in), paper: "us-letter", lang: "en", region: "CA", fonts: (), fontsize: 12pt, sectionnumbering: "1.1.a.", doc,
) = {
  // ===========================================================================
  // Setup components
  // ===========================================================================
  // Set par first-line-indent if needed
  show par: set block(spacing: if indent-first-line { 0.65em } else { 1em })
  set par(
    justify: true, first-line-indent: if indent-first-line { 1.5em } else { 0em },
  )

  // Set the language, region, font, fontsize and heading numbering
  set text(lang: lang, region: region, font: fonts, size: fontsize)
  set heading(numbering: sectionnumbering)

  // Make level 1 headings in toc bold and add vertical space
  show outline: set par(justify: true, first-line-indent: 0em)
  show outline.entry.where(level: 1): it => {
    v(0.5em)
    strong(it)
  }

  // Box around code blocks and remove justification
  show raw.where(block: true): it => {
    set par(justify: false)
    block(fill: luma(240), inset: 8pt, radius: 4pt, width: 100%)[#it]
  }

  // ===========================================================================
  // Utils
  // ===========================================================================
  // Properly formatthe path to a file
  let get-correct-path(text-path) = { return text-path.replace("\~", "~").replace("\_", "_") }

  // ===========================================================================
  // Setup page
  // ===========================================================================
  let ht-first = state("page-first-section", [])
  let ht-last = state("page-last-section", [])
  set page(
    paper: paper, margin: margin, header: context[
      #if counter(page).get().first() > 1 [
        #let left-content = if showdate { [#datetime.today().display("[year]/[month]/[day]")] } else { none }

        #grid(
          columns: (1fr, 1fr, 1fr), inset: 0.5em, align(left, left-content), align(center, title), align(right, [#authors.at(0).name | #authors.at(0).id]), grid.hline(),
        )
      ]
    ], footer: context[
      #if counter(page).get().first() > 1 [
        #let left-content = if class.instructor != none { align(left)[#text(size: 0.9em)[#class.instructor]] } else { none }
        #let center-content = counter(page).display(lang-map().numbering, both: true)
        #let right-content = locate(
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
                align(right, text(size: 0.9em)[Section #ht-first.display()])
              } else {
                align(right, text(size: 0.9em)[Section #ht-last.display()])
              }
            }
          ],
        )

        #grid(
          columns: (1fr, 1fr, 1fr), inset: 0.5em, grid.hline(), align(left, left-content), align(center, center-content), align(right, right-content),
        )
      ]
    ],
  )

  // ===========================================================================
  // Setup header with title page
  // ===========================================================================
  if titlepage {
    set text(size: 12pt)
    v(1fr)

    align(center)[
      #if title != none {
        smallcaps(text(size: 1.7em)[#title])
        linebreak()
      }
      #if subtitle != none {
        smallcaps(text(size: 1.45em)[#subtitle])
      }
    ]

    v(0.6fr)

    if authors != none {
      let count = authors.len()
      let ncols = calc.min(count, 2)
      grid(
        columns: (1fr,) * ncols, row-gutter: 1.5em, ..authors.map(author => align(center)[
          #if author.name != none {
            smallcaps(text(size: 1.45em)[#author.name])
            linebreak()
          }
          #if author.id != none {
            text(size: 1.2em)[#author.id]
            linebreak()
          }
          #if author.affiliation != none {
            smallcaps(text(size: 1.1em)[#author.affiliation])
            linebreak()
          }
          #if author.email != none {
            smallcaps(text(size: 1.1em)[#author.email])
          }
        ]),
      )
    }

    v(0.6fr)

    align(center)[
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

    v(0.5fr)

    align(center)[
      #if class.section != none {
        smallcaps(text(size: 1.2em)[Section #class.section])
        linebreak()
      }
      #if class.instructor != none {
        smallcaps(text(size: 1.2em)[#class.instructor])
      }

      #v(0.8fr)

      #if institution != none {
        smallcaps(text(size: 1.2em)[#institution])
        linebreak()
      }
      #if class.semester != none {
        text(size: 1.1em)[#class.semester]
        linebreak()
      }
      #if duedate != none {
        text(size: 1.1em)[#duedate]
      }

      #v(0.5fr)

      #if logo != none {
        let correct-path = get-correct-path([#logo].text)
        image(correct-path, width: 60%)
      }
    ]

    v(1.5fr)
    set text(size: fontsize)
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
      #text(weight: "semibold")[#translation("abstract")]
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
      #outline(title: auto, depth: none, indent: auto)
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
    bibliography(bib, title: translation("bib"), style: bibstyle)
  }
}
