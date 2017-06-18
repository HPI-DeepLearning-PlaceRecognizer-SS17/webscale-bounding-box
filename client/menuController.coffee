angular = require 'angular'

app = angular.module 'webscaleBoundingBox'

menuController = ($scope, Label) ->
  console.log 'MenuController'

  Label.query (labels) ->
    $scope.labels = labels
    console.log labels

  return

app.controller 'menuController', ['$scope', 'Label', menuController]