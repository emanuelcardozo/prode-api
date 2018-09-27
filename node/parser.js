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
    let finished = fields[j].split(' ')[0] === 'Fin'
    let homeField = fields[j+1]
    let awayField = fields[j+2]

    if(finished){
      _match={
        schedule: parseSchedule(fields[j], finished),
        home: {
          name: homeField.slice(homeField.indexOf(' ')+1),
          goals: parseInt(homeField.split(' ')[0])
        },
        away: {
          name: awayField.slice(awayField.indexOf(' ')+1),
          goals: parseInt(awayField.split(' ')[0])
        },
        state: 'Finished'
      }
    } else {
      _match={
        schedule: parseSchedule(fields[j], finished),
        home: {
          name: homeField
        },
        away: {
          name: awayField
        },
        state: 'Pending'
      }
    }
    // console.log(_match);
    stage.matches.push(_match)
  }
  return stage
}

function parseSchedule(scheduleField, finished){

  const scheduleSplited = scheduleField.split('►')[0].trim().split(' ')
  const index = finished ? 0 : 1
  const length = scheduleSplited.length
  const dateUndefined = scheduleSplited[1].includes("Por")

  return {
      dayOfWeek: finished && length===3 ? scheduleSplited[1] : null,
      date: dateUndefined? scheduleSplited[0] : scheduleSplited[length-index-1],
      hour: finished || dateUndefined ? null : scheduleSplited[2]
    }
}

module.exports = {
  parseStages,
  parseStage,
  parseSchedule,
}
