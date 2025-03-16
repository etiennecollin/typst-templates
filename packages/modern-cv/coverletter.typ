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

  show heading.where(level: 1): it => text(
    color-darkgray,
    size: 12pt,
    style: "normal",
    weight: "bold",
    it.body,
  )

  show heading.where(level: 2): it => text(
    size: 10pt,
    weight: "regular",
    smallcaps[#it.body],
  )

  show heading.where(level: 3): it => text(
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

  let signature = {
    align(bottom)[
      #text(weight: "light")[#linguify("sincerely")]
      #linebreak()
      #text(weight: "bold")[#author.firstname #author.lastname]
    ]
  }

  if closing == none {
    closing = align(bottom)[
      #text(weight: "light", style: "italic")[
        #linguify("attached"): #linguify("curriculum-vitae")
      ]
    ]
  }

  body
  linebreak()
  signature
  closing
}


/// Cover letter heading that takes in the information for the hiring company and formats it properly.
/// Letter heading for a given job position and addressee.
/// - entity-info (content): The information of the hiring entity including the company name, the target (who's attention to), street address, and city
/// - date (date): The date the letter was written (defaults to the current date)
/// - job-position (string): The job position you are applying for
/// - addressee (string): The person you are addressing the letter to
/// - dear (string): optional field for redefining the "dear" variable
#let coverletter-heading(
  entity-target: "",
  entity-name: "",
  entity-street-address: "",
  entity-city: "",
  date: datetime.today().display(),
  job-position: "",
  addressee: "",
  dear: "",
) = {
  set-database(toml("lang.toml"))

  let sections = ()

  if (
    entity-target != ""
      or entity-name != ""
      or entity-street-address != ""
      or entity-city != ""
  ) {
    assert(
      entity-target != ""
        and entity-name != ""
        and entity-street-address != ""
        and entity-city != "",
      message: "All fields of the entity must be filled.",
    )
    sections.push([
      #set par(leading: 1em)
      #pad(top: 0.4em)[
        #grid(
          columns: (1fr, auto),
          align: (left, right),
          text(weight: "bold", size: 12pt)[#entity-target],
          text(weight: "light", style: "italic", size: 9pt)[#date],
        )
        #text(weight: "regular", fill: color-gray, size: 9pt)[
          #smallcaps[#entity-name] \
          #entity-street-address \
          #entity-city \
        ]
      ]
    ])
  }


  let dear-content = if dear == "" [
    #linguify("dear")
  ] else [
    #dear
  ]

  if job-position != "" or addressee != "" {
    assert(
      job-position != "" and addressee != "",
      message: "Both job-position and addressee must be filled.",
    )
    sections.push(
      block()[
        = #linguify("letter-position-pretext") #job-position \
        == #dear-content #addressee \
      ],
    )
  }

  box(width: 1fr, line(length: 100%))
  sections.join(box(width: 1fr, line(length: 100%)))
  box(width: 1fr, line(length: 100%))
}

/// Cover letter content paragraph. This is the main content of the cover letter.
/// - content (content): The content of the cover letter
#let coverletter-content(content) = {
  pad(top: 0.4em)[
    #set par(first-line-indent: 3em)
    #set text(weight: "light")
    #content
  ]
}
