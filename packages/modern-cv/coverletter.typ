#import "@preview/linguify:0.4.1": *
#import "./constants.typ": *
#import "./utils.typ": *

/// Cover letter template that is inspired by the Awesome CV Latex template by posquit0. This template can loosely be considered a port of the original Latex template.
/// This coverletter template is designed to be used with the resume template.
/// - author (content): Structure that takes in all the author's information. The following fields are required: firstname, lastname, positions. The following fields are used if available: email, phone, github, linkedin, orcid, address, website.
/// - profile-picture (image): The profile picture of the author. This will be cropped to a circle and should be square in nature.
/// - date (datetime): The date the cover letter was created. This will default to the current date.
/// - accent-color (color): The accent color of the cover letter
/// - language (string): The language of the cover letter, defaults to "en". See lang.toml for available languages
/// - font (array): The font families of the cover letter
/// - show-footer (boolean): Whether to show the footer or not
/// - closing (content): The closing of the cover letter. This defaults to "Attached Curriculum Vitae". You can set this to `none` to show the default closing or remove it completely.
/// - body (content): The body of the cover letter
#let coverletter(
  author: (:),
  profile-picture: image,
  profile-picture-position: left,
  date: datetime.today().display(),
  closing: none,
  accent-color: default-accent-color,
  colored-headers: true,
  colored-name: true,
  show-footer: true,
  language: "en",
  font: ("Source Sans Pro", "Source Sans 3"),
  header-font: "Roboto",
  paper-size: "us-letter",
  body,
) = {
  assert(
    profile-picture-position == left or profile-picture-position == right,
    message: "The profile-picture-position must be either 'left' or 'right'.",
  )

  set-database(toml("lang.toml"))

  if type(accent-color) == str {
    accent-color = rgb(accent-color)
  }

  set text(
    font: font,
    lang: language,
    size: 11pt,
    fill: color-darkgray,
    fallback: true,
  )

  show: body => context {
    set document(
      author: author.firstname + " " + author.lastname,
      title: linguify("cover-letter"),
    )
    body
  }

  set page(
    paper: paper-size,
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: if show-footer [#__footer(
        author,
        language,
        date,
        linguify("cover-letter"),
      )] else [],
  )

  // set paragraph spacing
  set par(
    spacing: 0.75em,
    justify: true,
  )

  set heading(
    numbering: none,
    outlined: false,
  )

  show heading: it => [
    #set block(
      above: 1em,
      below: 1em,
    )
    #set text(
      size: 16pt,
      weight: "regular",
    )
    #let color = if colored-headers {
      accent-color
    } else {
      color-darkgray
    }

    #align(left)[
      #text[#strong[#text(color)[#it.body]]]
      #box(width: 1fr, line(length: 100%))
    ]
  ]


  create-header(
    author,
    profile-picture,
    profile-picture-position,
    accent-color,
    colored-name,
    header-font,
  )

  let signature = {
    align(bottom)[
      #pad(bottom: 2em)[
        #text(weight: "light")[#linguify("sincerely")] \
        #text(weight: "bold")[#author.firstname #author.lastname] \ \
      ]
    ]
  }

  if closing == none {
    closing = align(bottom)[
      #text(weight: "light", style: "italic")[
        #linguify("attached")#sym.colon #linguify("curriculum-vitae")]
    ]
  }


  body
  linebreak()
  signature
  closing
}

/// Cover letter heading that takes in the information for the hiring company and formats it properly.
/// - entity-info (content): The information of the hiring entity including the company name, the target (who's attention to), street address, and city
/// - date (date): The date the letter was written (defaults to the current date)
#let hiring-entity-info(
  entity-info: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
) = {
  set par(leading: 1em)
  pad(top: 1.5em, bottom: 1.5em)[
    #__justify_align[
      #text(weight: "bold", size: 12pt)[#entity-info.target]
    ][
      #text(weight: "light", style: "italic", size: 9pt)[#date]
    ]

    #pad(top: 0.65em, bottom: 0.65em)[
      #text(weight: "regular", fill: color-gray, size: 9pt)[
        #smallcaps[#entity-info.name] \
        #entity-info.street-address \
        #entity-info.city \
      ]
    ]
  ]
}

/// Letter heading for a given job position and addressee.
/// - job-position (string): The job position you are applying for
/// - addressee (string): The person you are addressing the letter to
/// - dear (string): optional field for redefining the "dear" variable
#let letter-heading(job-position: "", addressee: "", dear: "") = {
  set-database(toml("lang.toml"))

  // TODO: Make this adaptable to content
  underline(evade: false, stroke: 0.5pt, offset: 0.3em)[
    #text(
      weight: "bold",
      size: 12pt,
    )[#linguify("letter-position-pretext") #job-position]
  ]
  pad(top: 1em, bottom: 1em)[
    #text(weight: "light", fill: color-gray)[
      #if dear == "" [
        #linguify("dear")
      ] else [
        #dear
      ]
      #addressee,
    ]
  ]
}

/// Cover letter content paragraph. This is the main content of the cover letter.
/// - content (content): The content of the cover letter
#let coverletter-content(content) = {
  pad(top: 1em, bottom: 1em)[
    #set par(first-line-indent: 3em)
    #set text(weight: "light")
    #content
  ]
}
