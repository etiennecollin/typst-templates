#import "@preview/linguify:0.4.1": *
#import "./constants.typ": *

#let to-string(content) = {
  if type(content) == str {
    return content
  } else if content.has("text") {
    if type(content.text) == str {
      content.text
    } else {
      to-string(content.text)
    }
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let __footer(author, language, date, document_name) = {
  set text(
    fill: gray,
    size: 8pt,
  )
  grid(
    columns: (1fr, 1fr, 1fr),
    align: (left, center, right),
    rows: 1fr,
    smallcaps[#date],
    smallcaps[
      #author.firstname #author.lastname
      #sym.dot.c
      #document_name
    ],
    context {
      // We use #lflib._linguify as it allows conversion of the key to a string
      counter(page).display(
        to-string([1 #lflib._linguify("of").ok 1]),
        both: true,
      )
    },
  )
}

/// Show a link with an icon, specifically for Github projects
/// *Example*
/// #example(`resume.github-link("DeveloperPaul123/awesome-resume")`)
/// - github-path (string): The path to the Github project (e.g. "DeveloperPaul123/awesome-resume")
/// -> none
#let github-link(github-path) = {
  set box(height: 11pt)

  align(right + horizon)[
    #fa-icon("github", fill: color-darkgray) #link(
      "https://github.com/" + github-path,
      github-path,
    )
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let primary-justified-header(primary, secondary) = {
  pad(
    top: -0.3em,
    bottom: -0.3em,
    grid(
      columns: (1fr, auto),
      align: (left, right),
      [== #primary], [=== #secondary],
    ),
  )
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  grid(
    columns: (1fr, auto),
    align: (left, right),
    [=== #primary], [==== #secondary],
  )
}

#let create-header(
  author,
  profile-picture,
  profile-picture-position,
  accent-color,
  colored-name,
  header-font,
) = {
  let name = {
    pad(bottom: 5pt)[
      #block[
        #set text(
          size: 32pt,
          style: "normal",
          font: header-font,
        )
        #let name-color = if colored-name {
          accent-color
        } else {
          color-darkgray
        }
        #text(name-color, weight: "thin")[#author.firstname]
        #text(weight: "bold")[#author.lastname]
      ]
    ]
  }

  let positions = {
    set text(
      accent-color,
      size: 9pt,
      weight: "regular",
    )
    smallcaps[
      #author.positions.join(text[#"  "#sym.dot.c#"  "])
    ]
  }

  let address = {
    set text(
      size: 9pt,
      weight: "regular",
    )
    if ("address" in author) [
      #author.address
    ]
  }

  let contacts = {
    set box(height: 9pt)
    set text(
      size: 9pt,
      weight: "regular",
      style: "normal",
    )

    let separator = box(sym.bar.v)
    let keys = author.keys()
    block(
      author-info()
        .filter(field => keys.contains(field.id))
        .map(((id, icon, content)) => [
          #icon
          #content(author)
        ])
        .join(separator),
    )
  }

  let quotation = {
    set text(
      size: 9pt,
      weight: "regular",
    )
    if ("quotation" in author) [
      #author.quotation
    ]
  }

  if profile-picture != none {
    let picture-block = align(profile-picture-position + horizon)[
      #block(
        clip: true,
        stroke: 0pt,
        radius: 2cm,
        width: 4cm,
        height: 4cm,
        profile-picture,
      )
    ]

    let author-info-alignment = if profile-picture-position == left {
      right
    } else {
      left
    }
    let info-block = align(author-info-alignment + horizon)[
      #name
      #positions
      #address
      #contacts
      #quotation
    ]

    let left-block
    let right-block
    let column_sizes
    if profile-picture-position == left {
      left-block = picture-block
      right-block = info-block
      column_sizes = (4cm, 100% - 4cm)
    } else {
      left-block = info-block
      right-block = picture-block
      column_sizes = (100% - 4cm, 4cm)
    }

    grid(
      columns: column_sizes,
      rows: 100pt,
      gutter: 10pt,
      left-block,
      right-block,
    )
  } else {
    align(left + horizon)[
      name
      positions
      address
      contacts
    ]
  }
  v(0.2em)
}
