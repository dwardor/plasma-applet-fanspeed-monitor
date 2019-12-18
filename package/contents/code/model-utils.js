// mapping table for optimalization
var modelIndexesBySourceName = {}

/*
var exampleObject1 = {
    sourceName: 'lmsensors/nct6797-isa-0a20/fan1',
    deviceName: 'lmsensors/nct6797-isa-0a20/fan1',
    fanspeed: 39.8,
}
*/

/*
 * Fill fanspeedModel with "resources" configuration string.
 */
function initModels(savedSourceObjects, fanspeedModel) {
    savedSourceObjects.forEach(function (savedSourceObj) {
        var newObject = {
            sourceName: savedSourceObj.sourceName,
            alias: savedSourceObj.alias,
            fanspeed: 0,
        }
        fanspeedModel.append(newObject)
    })
    rebuildModelIndexByKey(fanspeedModel)
}

/*
 * Build map for optimizing fanspeed updating.
 * 
 * Must be explicitly called in Component.onCompleted method and after that add all sources to engines to start whipping data.
 */
function rebuildModelIndexByKey(existingModel) {
    modelIndexesBySourceName = {}
    for (var i = 0; i < existingModel.count; i++) {
        var obj = existingModel.get(i)
        dbgprint('indexing: ' + obj.sourceName + ' with index ' + i)
        addToListInMap(modelIndexesBySourceName, obj.sourceName, i)
    }
}

function addToListInMap(map, key, addObject) {
    var list = map[key] || []
    map[key] = list
    list.push(addObject)
}

/*
 * Sets fanspeed to existing fanspeedModel -> triggers visual update.
 */
function updateFanspeedModel(existingModel, sourceName, fanspeed) {
    
    var fanspeedToSet = fanspeed
    
    var indexes = modelIndexesBySourceName[sourceName] || []
    
    indexes.forEach(function (index) {
        
        dbgprint('setting property fanspeed to ' + fanspeedToSet + ', sourceName=' + sourceName + ', index=' + index)
        
        // update model
        setFanspeedToExistingModel(existingModel, index, fanspeedToSet)
        
    })
    
}

function setFanspeedToExistingModel(existingModel, index, fanspeedToSet) {
    existingModel.setProperty(index, 'fanspeed', fanspeedToSet)
}
