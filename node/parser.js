function parseStages( groupFields ){
  let allStages = []

  for( let i=0; i<groupFields.length; i++)
    allStages.push( parseStage(groupFields[i]) )
  return allStages
}

function parseStage( fields ){
  let stage = {
    name: fields[0],
    matches: []
  }

  for(let j=1; j<fields.length; j+=3){

    let _match = {}
    let hasGoals = fields[j].includes('Fin') || fields[j].includes('Suspendido')
    let homeField = fields[j+1]
    let awayField = fields[j+2]

    if(hasGoals){
      _match={
        schedule: parseSchedule(fields[j], hasGoals),
        home: {
          name: homeField.slice(homeField.indexOf(' ')+1),
          goals: parseInt(homeField.split(' ')[0])
        },
        away: {
          name: awayField.slice(awayField.indexOf(' ')+1),
          goals: parseInt(awayField.split(' ')[0])
        },
        state: fields[j].includes('Fin')? 'Finished' : 'Suspended'
      }
    } else {
      _match={
        schedule: parseSchedule(fields[j], hasGoals),
        home: {
          name: homeField
        },
        away: {
          name: awayField
        },
        state: fields[j].includes('Pospuesto')? 'Postponed' : 'Pending'
      }
    }
    // console.log(_match);
    stage.matches.push(_match)
  }
  return stage
}

function parseSchedule(scheduleField, hasGoals){

  const scheduleSplited = scheduleField.split('►')[0].trim().split(' ')
  const index = hasGoals ? 0 : 1
  const length = scheduleSplited.length
  const dateUndefined = scheduleField.includes("Pospuesto") || scheduleField.includes("Suspendido")
  const hourUndefined = scheduleField.includes("Por definirse")
  const unparsedDate = hourUndefined ? scheduleSplited[0]  : scheduleSplited[length-index-1]

  return {
    date: dateUndefined? null : parseDate(unparsedDate),
    hour: hasGoals || hourUndefined || dateUndefined ? null : scheduleSplited[length-1]
  }
}

function parseDate(unparsedDate){

  const today = new Date
  const slashCount = (unparsedDate.match(new RegExp('/', 'g')) || []).length
  var parsedDate = ''

  if(slashCount){
    const addYear = slashCount==1? '/'+ today.getFullYear() : ''

    if(slashCount==1)
      parsedDate = unparsedDate + addYear
    else {
      splitedDate = unparsedDate.split('/')
      parsedDate = splitedDate[0]+'/'+splitedDate[1]+'/20'+splitedDate[2]
    }

  } else {
    const tomorrow = new Date(today.getTime()+86400*1000)
    const date = unparsedDate==='Mañana'? today : tomorrow
    parsedDate = date.getDate() +'/'+ (date.getMonth()+1) +'/'+ date.getFullYear()
  }

  return parsedDate
}

module.exports = {
  parseStages,
  parseStage,
  parseSchedule,
}
