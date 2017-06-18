angular = require 'angular'

app = angular.module 'webscaleBoundingBox'

labelFactory = ($resource) ->
  return $resource('/labels')

app.factory 'Label', ['$resource', labelFactory]