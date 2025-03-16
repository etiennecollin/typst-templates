#import "@preview/fontawesome:0.5.0": *

#let color-darknight = rgb("#131A28")
#let color-darkgray = rgb("#333333")
#let color-gray = rgb("#5d5d5d")
#let default-accent-color = rgb("#262F99")
#let default-location-color = rgb("#333333")

#let linkedin-icon = box(
  fa-icon("linkedin", fill: color-darknight, solid: true),
)
#let github-icon = box(
  fa-icon("github-square", fill: color-darknight, solid: true),
)
#let twitter-icon = box(fa-icon("twitter", fill: color-darknight, solid: true))
#let google-scholar-icon = box(
  fa-icon("google-scholar", fill: color-darknight, solid: true),
)
#let orcid-icon = box(fa-icon("orcid", fill: color-darknight, solid: true))
#let phone-icon = box(
  fa-icon("square-phone", fill: color-darknight, solid: true),
)
#let email-icon = box(fa-icon("envelope", fill: color-darknight, solid: true))
#let birth-icon = box(fa-icon("cake", fill: color-darknight, solid: true))
#let homepage-icon = box(fa-icon("home", fill: color-darknight, solid: true))
#let website-icon = box(fa-icon("globe", fill: color-darknight, solid: true))


#let author-info() = (
  (
    id: "birth",
    icon: birth-icon,
    content: author => box[#text(author.birth)],
  ),
  (
    id: "birth",
    icon: birth-icon,
    content: author => box[#text(author.birth)],
  ),
  (
    id: "phone",
    icon: phone-icon,
    content: author => box[#text(author.phone)],
  ),
  (
    id: "email",
    icon: email-icon,
    content: author => box[#link("mailto:" + author.email)[#author.email]],
  ),
  (
    id: "homepage",
    icon: homepage-icon,
    content: author => box[#link(author.homepage)[
        #author.homepage.trim("https://").trim("http://")
      ]],
  ),
  (
    id: "github",
    icon: github-icon,
    content: author => box[#link(
        "https://github.com/" + author.github,
      )[#author.github]],
  ),
  (
    id: "linkedin",
    icon: linkedin-icon,
    content: author => box[
      #link(
        "https://www.linkedin.com/in/" + author.linkedin,
      )[#author.firstname #author.lastname]
    ],
  ),
  (
    id: "twitter",
    icon: twitter-icon,
    content: author => box[#link(
        "https://twitter.com/" + author.twitter,
      )[\@#author.twitter]],
  ),
  (
    id: "scholar",
    icon: google-scholar-icon,
    content: author => box[#link(
        "https://scholar.google.com/citations?user=" + author.scholar,
      )[#str(author.firstname + " " + author.lastname)]],
  ),
  (
    id: "orcid",
    icon: orcid-icon,
    content: author => box[#link(
        "https://orcid.org/" + author.orcid,
      )[#author.orcid]],
  ),
  (
    id: "website",
    icon: website-icon,
    content: author => box[#link(author.website)[
        #author.website.trim("https://").trim("http://")
      ]],
  ),
)
