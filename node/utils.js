function delay(timeout) {
  return new Promise((resolve) => {
    setTimeout(resolve, timeout);
  });
}

async function timeout(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function scrollTo(page, position){
  return page.evaluate((position) => document.getElementsByClassName('imso-fpm')[0].scrollTo(0,position))
}

function scrollToEnd(page){
  return page.evaluate(() => {
    let el = document.getElementsByClassName('imso-fpm')[0]
    el.scrollTo( 0, el.scrollHeight)
  })
}

function prettify(text){
  return text.trim().replace(/[\n\r]+|[\s]{2,}/g, ' ').split('  ')
}

module.exports = {
  timeout,
  scrollTo,
  scrollToEnd,
  prettify
}
