angular = require 'angular'

app = angular.module 'webscaleBoundingBox'

menuController = ($scope, Label) ->
  console.log 'MenuController'

  $scope.activeLabel = null

  $scope.filter = {
    ignoredImages: true
    goodBoundingBoxes: false
    okayishBoundingBoxes: false
    unprocessedImages: false
  }

  Label.query (labels) ->
    $scope.labels = labels
    $scope.setActiveLabel labels[0]
    return

  $scope.setActiveLabel = (label) ->
    $scope.activeLabel = label
    $scope.$emit 'activeLabelChange', label
    return

  $scope.filterChange = ->
    $scope.$emit 'filterChange', $scope.filter
    return

  return

app.controller 'menuController', ['$scope', 'Label', menuController]