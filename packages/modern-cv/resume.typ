#import "@preview/linguify:0.4.1": *
#import "./constants.typ": *
#import "./utils.typ": *

/// Resume template that is inspired by the Awesome CV Latex template by posquit0. This template can loosely be considered a port of the original Latex template.
///
/// The original template: https://github.com/posquit0/Awesome-CV
///
/// - author (content): Structure that takes in all the author's information
/// - profile-picture (image): The profile picture of the author. This will be cropped to a circle and should be square in nature.
/// - date (string): The date the resume was created
/// - accent-color (color): The accent color of the resume
/// - colored-headers (boolean): Whether the headers should be colored or not
/// - language (string): The language of the resume, defaults to "en". See lang.toml for available languages
/// - body (content): The body of the resume
/// -> none
#let resume(
  author: (:),
  profile-picture: image,
  profile-picture-position: left,
  date: datetime.today().display("[month repr:long] [day], [year]"),
  accent-color: default-accent-color,
  colored-headers: true,
  colored-name: true,
  show-footer: true,
  language: "en",
  font: ("Source Sans Pro", "Source Sans 3"),
  header-font: "Roboto",
  paper-size: "a4",
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
      title: linguify("resume"),
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
        linguify("resume"),
      )] else [],
  )

  set par(
    spacing: 0.75em,
    justify: true,
  )

  set heading(
    numbering: none,
    outlined: false,
  )

  show heading.where(level: 1): it => [
    #set text(
      size: 16pt,
      weight: "regular",
    )
    #set align(left)
    #let color = if colored-headers {
      accent-color
    } else {
      color-darkgray
    }

    #pad(top: -0.65em, bottom: -0.1em)[
      #text[#strong[#text(color)[#it.body]]]
      #box(width: 1fr, line(length: 100%))
    ]
  ]

  show heading.where(level: 2): it => text(
    color-darkgray,
    size: 12pt,
    style: "normal",
    weight: "bold",
    it.body,
  )

  show heading.where(level: 3): it => text(
    size: 10pt,
    weight: "regular",
    smallcaps[#it.body],
  )

  show heading.where(level: 4): it => text(
    size: 9pt,
    weight: "light",
    style: "italic",
    it.body,
  )

  create-header(
    author,
    profile-picture,
    profile-picture-position,
    accent-color,
    colored-name,
    header-font,
  )

  body
}

/// The base item for resume entries.
/// This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - body (content): The body of the resume entry
#let resume-item(body) = {
  set text(
    size: 10pt,
    style: "normal",
    weight: "light",
    fill: color-darknight,
  )
  set block(
    above: 0.75em,
    below: 1.25em,
  )
  set par(leading: 0.65em)
  block(above: 0.5em)[
    #body
  ]
}

/// Shows an award in the resume.
#let resume-award(title: "", description: "", date: "", location: "") = {
  block(above: 0.5em, below: 0.5em)[
    #resume-item[
      #grid(
        columns: (auto, auto, 1fr, auto),
        align: (left, left, left, right),
        [=== #date #h(0.5em)],
        [*#title*,#sym.space],
        description,
        [=== #h(0.5em) #location],
      )
    ]
  ]
}

/// Shows a detailed award in the resume.
#let resume-award-detailed(
  title: "",
  description: "",
  date: "",
  location: "",
) = {
  block(above: 0.5em, below: 0.65em)[
    #resume-item[
      #grid(
        columns: 1fr,
        row-gutter: 0.5em,
        grid(
          columns: (auto, 1fr, auto),
          align: (left, left, right),
          [=== #date #h(0.5em)],
          [*#title*,#sym.space],
          [=== #h(0.5em) #location],
        ),
        [#description],
      )
    ]
  ]
}

/// The base item for resume entries. This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - title (string): The title of the resume entry
/// - location (string): The location of the resume entry
/// - date (string): The date of the resume entry, this can be a range (e.g. "Jan 2020 - Dec 2020")
/// - description (content): The body of the resume entry
/// - title-link (string): The link to use for the title (can be none)
/// - accent-color (color): Override the accent color of the resume-entry
/// - location-color (color): Override the default color of the "location" for a resume entry.
#let resume-entry(
  title: none,
  subtitle: "",
  location: "",
  date: "",
  content: none,
  title-link: none,
  accent-color: default-accent-color,
  location-color: default-location-color,
) = {
  let title-content
  if type(title-link) == str {
    title-content = link(title-link)[#title]
  } else {
    title-content = title
  }
  block(above: 1em, below: 0.65em)[
    #pad[
      #primary-justified-header(title-content, location)
      #if subtitle != "" or date != "" [
        #secondary-justified-header(subtitle, date)
      ]
      #if content != "" {
        pad(left: 0.5em)[
          #content
        ]
      }
    ]
  ]
}

/// Show cumulative GPA.
/// *Example:*
/// #example(`resume.resume-gpa("3.5", "4.0")`)
#let resume-gpa(numerator, denominator) = {
  set text(
    size: 12pt,
    style: "italic",
    weight: "light",
  )
  text[Cumulative GPA: #box[#strong[#numerator] / #denominator]]
}

/// Show a certification in the resume.
/// *Example:*
/// #example(`resume.resume-certification("AWS Certified Solutions Architect - Associate", "Jan 2020")`)
/// - certification (content): The certification
/// - date (content): The date the certification was achieved
#let resume-certification(certification, date) = {
  primary-justified-header(certification, date)
}

/// Show a list of skills in the resume under a given category.
/// - items (array): This array contains dictionaries with the following keys:
//    - category (string): The category of the skills
//    - items (array): The list of skills
#let resume-skill-item(items) = {
  set block(below: 0.65em)

  pad(left: 1.5em)[
    #grid(
      columns: (auto, 1fr),
      align: (right, left),
      gutter: 0.4em,
      ..items
        .map(((category, items)) => (
          [ == #category ],
          [
            #set text(weight: "light")
            #if type(items) == array {
              items.join(", ")
            } else {
              items
            }
          ],
        ))
        .flatten()
    )
  ]
}
