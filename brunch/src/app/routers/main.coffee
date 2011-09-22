Resources = require('collections/resources').Resources
Resource = require('models/resource').Resource
ResourcesView = require('views/resources').ResourcesView
CreateResourceView = 
	require('views/create_resource').CreateResourceView
ResourceView = require('views/resource').ResourceView

Elements = require('collections/elements').Elements
ElementsView = require('views/elements').ElementsView

class exports.MainRouter extends Backbone.Router
  routes:
    '': 'index'
    'specifications': 'specifications'
    'createSpecification': 'createSpecification'
    ':specName/:specVersion/resources': 'resources'
    ':specName/:specVersion/createResource': 'createResource'
    'resource/:resourceId': 'resource'

  index: ->
    $('body').html app.views.index.render().el

  specifications: ->
    app.collections.specifications.fetch
      success: =>
        @_renderElement app.views.specifications.render().el
      error: =>
        @_handleError()
        @_renderElement app.views.specifications.render().el

  createSpecification: ->
    @_renderElement app.views.createSpecification.render().el

  resources: (specName, specVersion) ->
    resources = new Resources specName, specVersion
    resources.fetch
      success: (resources) =>
        resourcesView = new ResourcesView specName, specVersion, resources
        @_renderElement resourcesView.render().el
      error: =>
        @_handleError()
        resourcesView = new ResourcesView specName, specVersion
        @_renderElement resourcesView.render().el

  createResource: (specName, specVersion) ->
    createResourceView = new CreateResourceView(specName, specVersion)
    @_renderElement createResourceView.render().el

  resource: (resourceId) ->
    resource = new Resource resourceId: resourceId
    resource.fetch
      success: (model) =>
        resourceView = new ResourceView(model)
        @_renderElement resourceView.render().el
        elementsHref = model.get 'elementsHref'
        @_renderElements resourceView, elementsHref
      error: =>
        @_handleError()

  _renderElements: (view, elementsHref) ->
    elements = new Elements elementsHref
    elements.fetch
      success: (collection) =>
        elementsView = new ElementsView elements: collection
        view.renderElements elementsView
      error: =>
        @_handleError()

  _handleError: ->

  _renderElement: (element) ->
    $('body').html element
