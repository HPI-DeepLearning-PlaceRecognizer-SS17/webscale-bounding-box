angular = require 'angular'

app = angular.module 'webscaleBoundingBox'

menuController = ($scope, Label) ->
  console.log 'MenuController'

  $scope.activeLabel = null

  Label.query (labels) ->
    $scope.labels = labels
    $scope.setActiveLabel labels[0]
    return

  $scope.setActiveLabel = (label) ->
    $scope.activeLabel = label
    $scope.$emit 'activeLabelChange', label
    return

  return

app.controller 'menuController', ['$scope', 'Label', menuController]