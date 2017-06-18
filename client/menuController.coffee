angular = require 'angular'

app = angular.module 'webscaleBoundingBox'

menuController = ($scope) ->
  console.log 'MenuController'
  return

app.controller 'menuController', ['$scope', menuController]