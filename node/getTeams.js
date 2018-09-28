const puppeteer = require('puppeteer')
const parser = require('./parser')
const utils = require('./utils')
const fs = require('fs')

const url = 'https://www.google.com.ar/search?q=posiciones+'
const leagues = ['liga española', 'superliga argentina', 'premier league']

puppeteer.launch({ headless: true }).then(async browser => {
  console.log("\n################ GETTING TEAMS ################\n")

  const page = await browser.newPage()

  await page.goto(url)

  const matchesButton = await page.$('g-immersive-footer')
  await matchesButton.click()
  await utils.timeout(1000)

  let allTeams = await getTeams(page)
  fs.writeFileSync('./node/teams.json', JSON.stringify(allTeams))

  await browser.close()

}).catch(err => {
  console.log(err)
  process.exit(1)
})

function getTeams(page){
  return page.evaluate(() => [...document.querySelectorAll('.str-dc.str-nhnc')].slice(5).map( el => {
      const html = el.innerHTML
      return new Object({
        name: el.innerText.trim().replace(/[\n\r]+|[\s]{2,}/g, ' '),
        logo: html.slice(html.indexOf('ssl'), html.indexOf('" style'))
      })
    }))
}
