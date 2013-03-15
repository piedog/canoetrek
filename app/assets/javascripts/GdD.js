var GdD = {};
GdD.Test = function() {};

GdD.Test.prototype = {
    options: { buttonId: "default-link", msg: "Default message" },

    init : function() {
        // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {                
    defaultHandlerOptions: {
        'single': true,
        'double': false,
        'pixelTolerance': 0,
        'stopSingle': false,
        'stopDouble': false
    },

    initialize: function(options) {
        this.handlerOptions = OpenLayers.Util.extend(
            {}, this.defaultHandlerOptions
        );
        OpenLayers.Control.prototype.initialize.apply(
            this, arguments
        ); 
        this.handler = new OpenLayers.Handler.Click(
            this, {
                'click': this.trigger
            }, this.handlerOptions
        );
    }, 

    trigger: function(e) {
        var lonlat = map.getLonLatFromPixel(e.xy);
        lonlat.transform(map.projection, map.displayProjection);
        var zoomlevel = map.getZoom();
        var extent = map.getExtent();
        extent.transform(map.projection, map.displayProjection);
        $('#footer').html("Center: "+lonlat.lon + " N, "
            + lonlat.lat + " E<br />Zoom: "+zoomlevel
            + "<br />Extent: "+extent);
    }

});

var wmsServerUrl = "http://www1.4net2.net:8080/geoserver/wms";
OpenLayers.ProxyHost = "/cgi-bin/proxy?url=";

Proj4js.defs['EPSG:4269'] = '+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs';
var geographic = new OpenLayers.Projection("EPSG:4269");
var mercator = new OpenLayers.Projection('EPSG:900913');

function formatFeatureRow(htmlLoc, at) {
    htmlLoc.append(
        '<div>'
        +'<div class="attr-disp-cell gid" style="width:15%;">'+at.gid+'</div>'
        +'<div class="attr-disp-cell" style="width:40%;">'+at.name+'</div>'
        +'<div class="attr-disp-cell" style="width:15%;">'+at.state+'</div>'
        +'<div class="attr-disp-cell" style="width:15%;">'+at.fnode_+'</div>'
        +'<div class="attr-disp-cell" style="width:15%;">'+at.tnode_+'</div>'
        +'</div>'
    );
}

var map = new OpenLayers.Map({
    div: "map-container",
    digitizeMode: false,
    selectedFeaturesDiv : null,
    clearAllFeatures: function() {
        this.getLayersByName("Selection")[0].destroyFeatures();
    },
    layers: [
        new OpenLayers.Layer.XYZ("OSM (without buffer)",
            [
                "http://a.tile.openstreetmap.org/${z}/${x}/${y}.png",
                "http://b.tile.openstreetmap.org/${z}/${x}/${y}.png",
                "http://c.tile.openstreetmap.org/${z}/${x}/${y}.png"
            ],
            {
                transitionEffect: "resize", buffer: 0, sphericalMercator: true,
                attribution: "Data CC-By-SA by <a href='http://openstreetmap.org/'>OpenStreetMap</a>"
            }
        ),

        new OpenLayers.Layer.WMS( "USGS", wmsServerUrl,
                {layers: "DRGtopos"},
                {isBaseLayer:true}
        ),
        new OpenLayers.Layer.WMS("Faults", wmsServerUrl,
                {layers: "Faults", transparent: true },
                {isBaseLayer: false, opacity: 0.5 }
        ),
        new OpenLayers.Layer.WMS("Geoserver", wmsServerUrl,
                {layers: "giserv:trips", transparent: true},
                {isBaseLayer: false, opacity: 0.5 }
        ),
        new OpenLayers.Layer.Vector("Selection",{
            styleMap: new OpenLayers.StyleMap(OpenLayers.Util.applyDefaults(
                {strokeColor: "blue", strokeWidth: 7, strokeOpacity: 0.25 },
                OpenLayers.Feature.Vector.style["select"])
            )
        })
    ],
    controls: [
        new OpenLayers.Control.Navigation({
            dragPanOptions: {
                enableKinetic: true
            }
        }),
        new OpenLayers.Control.PanZoom(),
        new OpenLayers.Control.Attribution(),
        new OpenLayers.Control.MousePosition(),
        new OpenLayers.Control.Click({'name':'clickcontrol'}),
        new OpenLayers.Control.LayerSwitcher()
    ],

    center: [-10545985, 4323684],
    zoom: 9,
    tripPath: [],
    addToTripPath: function(o) {
        var self = this;
        self.tripPath[self.tripPath.length] = o;
    },
    rmFromTripPath: function(o) {
        var self = this;
        var el = -1;
        $.each(self.tripPath, function(idx, val) {
            if (o.gid == val.gid) {
                el = idx;
                return;
            }
        });
        if (el > -1) self.tripPath.splice(el,1);
    },

    getFeatureList: function() {
        return this.getLayersByName('Selection')[0].features;
    },
    

    init: function() {
        var self = this;
        var click = self.getControlsBy('name', 'clickcontrol')[0];
        click.activate();

        var selectLayer = this.getLayersByName("Selection")[0];
        selectLayer.events.on({
            'featuresadded'  : function(f) {
                //alert('feature added');
                if (!self.selectedFeaturesDiv) return;
                $.each(f.features, function(i,v) {
                    formatFeatureRow( $("#"+self.selectedFeaturesDiv), v.attributes);
                })
            },
            'featuresremoved': function(f) {
                $.each(f.features, function(i,v) {
                    $('#'+self.selectedFeaturesDiv+' div.gid').filter(function() {
                        return $(this).text() == v.attributes.gid;
                    }).parent().remove();
                });
            },
            scope: selectLayer
        });
    },
    projection: mercator,
    displayProjection: geographic,
    setDigitizeMode: function(mode) {
        var self = this;
        self.digitizeMode = mode;
        var selCtl = self.getControlsBy("robsid","getfeature")[0];
        if (mode) selCtl.activate();
        else selCtl.deactivate();
    },
    selectByQuery: function(filtOpts) {
        var ly = this.getLayersByName('Selection')[0];
        var defFilter = createFilter(filtOpts);
        map.queryProtocol.defaultFilter = defFilter;
        var response = map.queryProtocol.read({
            maxFeatures:100,
            callback: function(r) {
                if (filtOpts.clear) ly.destroyFeatures();
                ly.addFeatures(r.features);
                var ext = new OpenLayers.Bounds();
                for (var i=0;i<r.features.length;i++)
                    ext.extend(r.features[i].geometry.getBounds());
                ly.map.zoomToExtent(ext);
            }
        });
    },
    addTripToMap: function(name, title, synopsis, centerLon, centerLat, zoom) {
        var lyr = this.getLayersByName('TripList')[0];
        alert ('aoicenter: '+centerLon+', '+centerLat);
        var lonLat = new OpenLayers.LonLat(centerLon, centerLat);
        lonLat.transform(geographic, mercator);
        this.setCenter(lonLat, zoom);
    },
    markTripAsDeleted: function(id) {
    },
    zoomToSelectedTrip: function(data) {
        var lonLat = new OpenLayers.LonLat(data.lon, data.lat);
        lonLat.transform(geographic, mercator);
        this.setCenter(lonLat, data.zoom);
    }
});

$(window).ready(function() {
    setTimeout(function() { map.updateSize(); });
    map.init();
});


function createFilter(filtOpts) {
    if (!filtOpts || !filtOpts.filterParams) return null;
    
    var fAnd = new OpenLayers.Filter.Logical({
        type: OpenLayers.Filter.Logical.AND,
        filters: []
    });
 

    $.each(filtOpts.filterParams, function(i0,v0) {
        var fOr = new OpenLayers.Filter.Logical({
            type: OpenLayers.Filter.Logical.OR,
            filters: []
        });
        $.each(v0.vals, function(i1, v1) {
            fOr.filters.push({
                type     : OpenLayers.Filter.Comparison.EQUAL_TO,
                property : v0.prop,
                value    : v1
            });
        });
        fAnd.filters.push(fOr);
    });
    return fAnd;
}
        // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    }
};
