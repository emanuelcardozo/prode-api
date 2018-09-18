function parseDatesMatch( groupFields ){
  let allDatesMatch = []

  for( let i=0; i<groupFields.length; i++)
    allDatesMatch.push( parseDateMatch(groupFields[i]) )
  return allDatesMatch
}

function parseDateMatch( fields ){
  let dateMatch = {
    name: fields[0],
    matches: []
  }

  for(let j=1; j<fields.length; j+=3){

    let _match = {}
    let finished = fields[j].split(' ')[0] === 'Fin'
    let localField = fields[j+1]
    let visitantField = fields[j+2]

    if(finished){
      _match={
        schedule: parseSchedule(fields[j], finished),
        local: {
          name: localField.slice(localField.indexOf(' ')+1),
          goals: parseInt(localField.split(' ')[0])
        },
        visitant: {
          name: visitantField.slice(visitantField.indexOf(' ')+1),
          goals: parseInt(visitantField.split(' ')[0])
        },
        state: 'Finished'
      }
    } else {
      _match={
        schedule: parseSchedule(fields[j], finished),
        local: {
          name: localField
        },
        visitant: {
          name: visitantField
        },
        state: 'Pending'
      }
    }
    console.log(_match);
    dateMatch.matches.push(_match)
  }
  return dateMatch
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
  parseDatesMatch,
  parseDateMatch,
  parseSchedule,
}
