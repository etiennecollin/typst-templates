// =============================================================================
// Basic utils
// =============================================================================
// Convert content to string by recursively traversing the
// content tree and merging children
// Source: https://github.com/typst/typst/issues/2196#issuecomment-1728135476
#let to-string(content) = {
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
#let lang-map() = if text.lang == "fr" {
  (
    numbering: "1 sur 1", abstract: "Résumé", bib: "Bibliographie", definition: "Définition", example: "Exemple", problem: "Problème", proposition: "Proposition", theorem: "Théorem", explanation: "Explication", lemma: "Lemme", corollary: "Corollaire", remark: "Remarque", claim: "Assertion", proof: "Preuve", note: "Note", solution: "Solution", fact: "Fait",
  )
} else {
  (
    numbering: "1 of 1", abstract: "Abstract", bib: "References", definition: "Definition", example: "Example", problem: "Problem", proposition: "Proposition", theorem: "Theorem", explanation: "Explanation", lemma: "Lemma", corollary: "Corollary", remark: "Remark", claim: "Claim", proof: "Proof", note: "Note", solution: "Solution", fact: "Fact",
  )
}

// Provides a word in the right language given a key
#let translation(key) = context lang-map().at(key)

// =============================================================================
// Custom functions
// =============================================================================
#let box-colors = (
  default: (stroke: luma(70), fill: white, title: white), red: (stroke: rgb("#8C441A"), fill: rgb("#f9f6f4"), title: rgb("#633012")), lightred: (stroke: rgb("#8C441A"), fill: rgb("#fefdfd"), title: rgb("#633012")), green: (stroke: rgb("#458933"), fill: rgb("#f6f9f5"), title: rgb("#316124")), blue: (stroke: rgb("#00007B"), fill: rgb("#f2f2f8"), title: rgb("#000055")), lightblue: (stroke: rgb("#00007B"), fill: rgb("#fcfcfe"), title: rgb("#000055")),
)

#let colorbox(title: none, color: "default", radius: 2pt, width: auto, body) = {
  let color = box-colors.at(color)

  return block(
    fill: color.fill, stroke: (left: 2pt + color.stroke, rest: 2pt + color.fill), radius: radius, width: width,
  )[
    #block(inset: 8pt, width: 100%)[
      #if title != none [
        #text(fill: color.title, weight: "bold")[#title.]
      ]
      #body
    ]
  ]
}

#let definition(body) = [ #colorbox(title: translation("definition"), color: "green", body) ]
#let example(body) = [ #colorbox(title: translation("example"), color: "blue", body) ]
#let problem(body) = [ #colorbox(title: translation("problem"), color: "blue", body) ]
#let proposition(body) = [ #colorbox(title: translation("proposition"), color: "red", body) ]
#let theorem(body) = [ #colorbox(title: translation("theorem"), color: "red", body) ]
#let explanation(body) = [ #colorbox(title: translation("explanation"), color: "lightblue", body) ]
#let lemma(body) = [ #colorbox(title: translation("lemma"), color: "red", body) ]
#let corollary(body) = [ #colorbox(title: translation("corollary"), color: "red", body) ]
#let remark(body) = [ #colorbox(title: translation("remark"), color: "blue", body) ]
#let claim(body) = [ #colorbox(title: translation("claim"), color: "blue", body) ]
#let proof(body) = [ #colorbox(title: translation("proof"), color: "lightred", body) ]
#let note(body) = [ #colorbox(title: translation("note"), color: "blue", body) ]
#let solution(body) = [ #colorbox(title: translation("solution"), color: "blue", body) ]
#let fact(body) = [ #colorbox(title: translation("fact"), color: "blue", body) ]
