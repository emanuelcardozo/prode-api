const puppeteer = require('puppeteer')
const parser = require('./parser')
const utils = require('./utils')
const fs = require('fs')

const url = 'https://www.google.com.ar/search?q=premier+league'

puppeteer.launch({ headless: true }).then(async browser => {
  console.log("\n################ GETTING RESULTS TEST ################\n")

  const page = await browser.newPage()

  await page.goto(url)

  const matchesButton = await page.$('g-immersive-footer')
  await matchesButton.click()
  await utils.timeout(1000)

  let allTeams = await getTeams(page)
  console.log(allTeams);
  fs.writeFileSync('./node/teams.json', JSON.stringify(allTeams))

  await browser.close()

}).catch(err => {
  console.log(err)
  process.exit(1)
})

function getTeams(page){
  return page.evaluate(() => [...document.querySelectorAll('jsl')][2].innerHTML.split('class="imspo_mt__tr"').map( html => {
      return new Object({
        name: html.slice(html.indexOf('="22">')+6).split('<')[0],
        logo: html.slice(html.indexOf('ssl'), html.indexOf('" alt'))
      })
    }).slice(1,21))
}
