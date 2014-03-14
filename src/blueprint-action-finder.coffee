
class Finder
  constructor: (@ast) ->

  find: (action) ->
    structure = action.split /\s*>\s*/
    throw 'Action path is not complete' if structure.length < 3

    result = {}

    filteredGroups = @ast.resourceGroups.filter (group) ->
      return group.name == structure[0]
    throw 'Group "' + structure[0] + '" was not found' if filteredGroups.length < 1
    result.group = filteredGroups[0]

    filteredResources = result.group.resources.filter (resource) ->
      return resource.name == structure[1]
    throw 'Resource "' + structure[1] + '" was not found' if filteredResources.length < 1
    result.resource = filteredResources[0]

    filteredActions = result.resource.actions.filter (action) ->
      return action.name == structure[2]
    throw 'Action "' + structure[2] + '" was not found' if filteredActions.length < 1
    result.action = filteredActions[0]

    return result

module.exports = Finder
