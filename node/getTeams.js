const puppeteer = require('puppeteer')
const parser = require('./parser')
const utils = require('./utils')
const fs = require('fs')

const url = 'https://www.google.com.ar/search?q=posiciones+super_liga+argetina'
// const leagues = ['liga española', 'superliga argentina', 'premier league']

puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] }).then(async browser => {
  console.log("\n################ GETTING TEAMS ################\n")

  const page = await browser.newPage()

  await page.goto(url)

  const matchesButton = await page.$('g-immersive-footer')
  await matchesButton.click()
  await utils.timeout(5000)

  let allTeams = await getTeams(page)
  console.log(allTeams);

  console.log('################ PROCESS SUCCESSFUL ################')

  fs.writeFileSync('./node/teams.json', JSON.stringify(allTeams))

  await browser.close()

}).catch(err => {
  console.log('################ ERROR ################');
  console.log(err)
  process.exit(1)
})

function getTeams(page){
  return page.evaluate(() => [...document.querySelectorAll('.str-dc.str-nhnc')].slice(5).map( el => {
      const html = el.innerHTML
      const logoURL = html.slice(html.indexOf('//ssl'), html.indexOf('48x48'))
      return new Object({
        name: el.innerText.trim().replace(/[\n\r]+|[\s]{2,}/g, ' '),
        logo: {
          small: logoURL + "24x24.png",
          medium: logoURL + "48x48.png",
          large:  logoURL + "96x96.png",
        }
      })
    }))
}
