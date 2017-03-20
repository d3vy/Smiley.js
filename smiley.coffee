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

toggleSmiley = -> $(@).toggleClass('active')

prepareSmileys = (html)->
  smileysFound = html.match(/[:Xx][-]?[\)\(OoDPp\*]/g)
  html = checkForSmiley(html, smiley, false) for smiley in smileysFound if smileysFound
  inverseSmileysFound = html.match(/[\(\)d][-]?:/g)
  html = checkForSmiley(html, smiley, true) for smiley in inverseSmileysFound if inverseSmileysFound
  html = checkForSmiley(html, extra, extras[extra]) for extra in extras
  html

checkForSmiley = (html, smiley, isReverse)->
  index = html.indexOf(smiley)
  replace = null
  while index >= 0
    replace = prepareSmiley(smiley, isReverse) if not replace
    html = replaceString(html, replace, index, index + smiley.length)
    index = html.indexOf(smiley, index + replace.length)
  html

prepareSmiley = (smiley, isReverse)->
  html = '<span class="smiley-wrapper">' +
      '<span class="smiley' + (if isReverse then ' smiley-reverse' else '') + '">'
  for i in [0...smiley.length]
    if smiley[i] in smileParts
      html += '<span class="' + smileParts[smiley[i]] + '">' + smiley[i] + '</span>'
    else
      html += smiley[i]
  html += '</span>' +
    '</span>'
  html

replaceString = (string, replace, from, to)-> string.substring(0, from) + replace + string.substring(to)

fixSmiles = (content)-> content.html(prepareSmileys(content.html()))

$(document).on('click', '.smiley', toggleSmiley)

$.fn.smilify = ->
  $els = $(@).each(-> fixSmiles($(@)))
  setTimeout(
    -> $els.find('.smiley').each(toggleSmiley)
    20
  )
  @
