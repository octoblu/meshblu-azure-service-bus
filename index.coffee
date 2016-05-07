_               = require 'lodash'
MeshbluHttp     = require 'meshblu-http'
MeshbluConfig   = require 'meshblu-config'
azure           = require 'azure'
async           = require 'async'

meshbluConfig = new MeshbluConfig().toJSON()

meshblu  = new MeshbluHttp meshbluConfig

meshblu.whoami (error, {connectionString, queueName}) =>
  serviceBusService = azure.createServiceBusService connectionString
  async.forever (callback) =>
    serviceBusService.receiveQueueMessage queueName, (error, message) =>
      return callback() if error?.message == "No messages to receive"
      meshblu.message devices: ['*'], message: message, error: error
      callback()
