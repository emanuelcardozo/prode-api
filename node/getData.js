const puppeteer = require('puppeteer')
const parser = require('./parser')
const utils = require('./utils')
const fs = require('fs')

const url = 'https://www.google.com.ar/search?q=liga+argentina'

puppeteer.launch({ headless: true }).then(async browser => {
  console.log("\n################ GETTING RESULTS TEST ################\n")

  const page = await browser.newPage()

  await page.goto(url)

  const matchesButton = await page.$('g-immersive-footer')
  await matchesButton.click()


  await utils.timeout(1000)
  await utils.scrollTo(page, 0)
  await utils.timeout(1000)
  await utils.scrollToEnd(page)
  await utils.timeout(1000)
  await utils.scrollToEnd(page)
  await utils.timeout(1000)
  await utils.scrollToEnd(page)
  await utils.timeout(1000)
  await utils.scrollToEnd(page)
  await utils.timeout(1000)
  await utils.scrollToEnd(page)
  await utils.timeout(1000)
  await utils.scrollToEnd(page)
  await utils.timeout(1000)
  await utils.scrollToEnd(page)
  await utils.timeout(1000)
  await page.screenshot({path: 'example.png'});

  const stages = await getAllStages(page)

  stages.forEach( (date, index)=>{
      if(!date[0].includes('Jornada'))
        stages[index-1].push(...date)
  })

  // console.log(stages.filter( el => el[0].includes('Jornada') ));
  let allStages = parser.parseStages( stages.filter( el => el[0].includes('Jornada') ) )
  console.log(allStages);

  //fs.writeFileSync('./node/super_liga.json', JSON.stringify(allStages))

  await browser.close()

}).catch(err => {
  console.log(err)
  process.exit(1)
})

function getAllStages(page){
  return page.evaluate(() => [...document.querySelectorAll('.OcbAbf')].map(elem => elem.innerText.trim().replace(/[\n\r]+|[\s]{2,}/g, ' ').split('  ')))
}

function getStage(page){
  return page.evaluate(() => [document.querySelector('jsl')].map(elem => elem.innerText.trim().replace(/[\n\r]+|[\s]{2,}/g, ' ').split('  ')))
}
