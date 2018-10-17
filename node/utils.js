const fs = require('fs')
const PNG = require('pngjs').PNG
const expect = require('chai').expect
const pixelmatch = require('pixelmatch')

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

function getNumberOfStage(stage, selector ){
  return parseInt(stage.split(' ').slice(selector==='current'? -3 : -1)[0])
}

// async function areDifferentImages(beforeScrollImgPath, afterScrollImgPath){
//   return compareImages(beforeScrollImgPath, afterScrollImgPath)
// }

async function areDifferentImages(beforeScrollImgPath, afterScrollImgPath){
  return new Promise(( resolve, reject) => {
    const img1 = fs.createReadStream(beforeScrollImgPath).pipe(new PNG()).on('parsed', doneReading)
    const img2 = fs.createReadStream(afterScrollImgPath).pipe(new PNG()).on('parsed', doneReading)

    let filesRead = 0
    function doneReading() {
      // Wait until both files are read.
      if (++filesRead < 2) return

      // The files should be the same size.
      expect(img1.width, 'image widths are the same').equal(img2.width)
      expect(img1.height, 'image heights are the same').equal(img2.height)

      // Do the visual diff.
      const diff = new PNG({width: img1.width, height: img2.height})
      const numDiffPixels = pixelmatch(
          img1.data, img2.data, diff.data, img1.width, img1.height,
          {threshold: 0.1})

      if( numDiffPixels > 1000 )
        resolve(true)
      else
        resolve(false)
    }
  })
}

module.exports = {
  timeout,
  scrollTo,
  scrollToEnd,
  prettify,
  getNumberOfStage,
  areDifferentImages
}
