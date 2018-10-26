const puppeteer = require('puppeteer')
const parser = require('./parser')
const utils = require('./utils')
const fs = require('fs')

const url = 'https://www.google.com.mx/search?q=liga+argetina'

puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] }).then(async browser => {
  console.log("\n################ GETTING TOURNAMENT ################\n")

  const page = await browser.newPage()

  await page.goto(url)

  const matchesButton = await page.$('g-immersive-footer')
  await matchesButton.click()
  await utils.timeout(5000)

  var stagesName = await getStagesName(page)
  const lastStageToLoad = utils.getNumberOfStage(stagesName[0], 'last')
  var lastStageLoaded = utils.getNumberOfStage(stagesName[stagesName.length-1], 'current')
  var firstStageLoaded = utils.getNumberOfStage(stagesName[0], 'current')


  while( firstStageLoaded > 1){
    await utils.scrollTo(page, 0)
    await utils.timeout(5000)
    stagesName = await getStagesName(page)
    firstStageLoaded = utils.getNumberOfStage(stagesName[0], 'current')
  }

  await utils.scrollTo(page, 0)
  await utils.timeout(5000)

  while( lastStageLoaded < lastStageToLoad ){
    await utils.scrollToEnd(page)
    await utils.timeout(5000)
    stagesName = await getStagesName(page)
    lastStageLoaded = utils.getNumberOfStage(stagesName[stagesName.length-1], 'current')
  }

  await utils.scrollToEnd(page) // por las dudas de que no carguen todos los partidos
  await utils.timeout(5000)

  const unParsedTournament = await getTournament(page)

  unParsedTournament.stages.forEach( (stage, index)=>{
      if(!stage[0].includes('Jornada') && !stage[0].includes('Matchday')){
        while(!unParsedTournament.stages[index-1][0].includes('Jornada') && !unParsedTournament.stages[index-1][0].includes('Matchday'))
          index--
        unParsedTournament.stages[index-1].push(...stage)
      }
  })

  let tournament = {
    name: unParsedTournament.name,
    stages: parser.parseStages( unParsedTournament.stages.filter( el => el[0].includes('Jornada') || el[0].includes('Matchday') ) )
  }
  console.log(tournament);

  fs.writeFileSync('./node/super_liga.json', JSON.stringify(tournament))

  await browser.close()
  console.log('################ PROCESS SUCCESSFUL ################')

}).catch(err => {
  console.log('################ ERROR ################')
  console.log(err)
  process.exit(1)
})

function getTournament(page){
  return page.evaluate(() => {
    return {
      name: [document.querySelector('.ofy7ae')][0].innerText,
      stages: [...document.querySelectorAll('.OcbAbf')].map(elem => elem.innerText.trim().replace(/[\n\r]+|[\s]{2,}/g, ' ').split('  '))
    }
  })
}

function getStagesName(page){
  return page.evaluate(() => [...document.querySelectorAll('.GVj7ae')].map(elem => elem.innerText))
}


// function getStage(page){
//   return page.evaluate(() => [document.querySelector('jsl')].map(elem => elem.innerText.trim().replace(/[\n\r]+|[\s]{2,}/g, ' ').split('  ')))
// }
