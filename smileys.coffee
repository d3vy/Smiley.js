smileys = [
  ':('
  ':)'
  ':O'
  ':D'
  ':p'
  ':*'
  ':-)'
  ':-('
  ':-O'
  ':-D'
  ';)'
  ';-)'
  ':P'
  'xD'
]

extras = {
  '<3': true
  '&lt;3': true
}

smileParts = {
  'O': 'middle-mouth'
  'D': 'middle-mouth'
  'd': 'middle-mouth'
  'p': 'low-mouth'
  '*': 'high-mouth'
  '-': 'nose'
  'P': 'middle-mouth'
}

oppositeSmileParts = {
  'p': 'd'
  ')': '('
  '(': ')'
  'P': 'd'
}

reverseSmileys = []

for i in [0...smileys.length]
  reverse = ''

  for j in [smileys[i].length-1..0]
    char = smileys[i][j]

    if char in oppositeSmileParts
      reverse += oppositeSmileParts[smileys[i][j]]
    else
      reverse += smileys[i][j]

  reverseSmileys.push(reverse)

toggleSmiley = ->
  $(@).toggleClass('active')

prepareSmileys = (html)->
  html = checkForSmiley(html, extra, extras[extra]) for extra in extras
  html = checkForSmiley(html, smileys[i], false) for i in [smileys.length-1..0]
  html = checkForSmiley(html, reverseSmileys[i], true) for i in [reverseSmileys.length-1..0]
  html

checkForSmiley = (html, smiley, isReverse)->
  index = html.indexOf(smiley)
  replace = null
  while index >= 0
    replace = prepareSmiley(smiley, isReverse) if replace == null
    html = replaceString(html, replace, index, index + smiley.length)
    index = html.indexOf(smiley, index + replace.length)
  html

prepareSmiley = (smiley, isReverse)->
  html = '<span class="smiley-wrapper">' +
      '<span class="smiley' + (isReverse ? 'smiley-reverse' : '') + '">'

  for i in [0...smiley.length]
    if smiley[i] in smileParts
      html += '<span class="' + smileParts[smiley[i]] + '">' + smiley[i] + '</span>'
    else
      html += smiley[i]

  html += '</span>' +
    '</span>'

  html

replaceString = (string, replace, from, to)->
  string.substring(0, from) + replace + string.substring(to)

fixSmiles = ($el)->
  smiles = prepareSmileys($el.html())
  $el.html(smiles)

$(document).on('click', '.smiley', toggleSmiley)

$.fn.smilify = ->
  $els = $(@).each(->
    fixSmiles($(@))
  )
  setTimeout(
    -> $els.find('.smiley').each(toggleSmiley)
    20
  )
  @
