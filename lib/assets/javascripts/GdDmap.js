GdD.Map = function() {};

Proj4js.defs['EPSG:4269'] = '+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs';
GdD.GEOGRAPHIC = new OpenLayers.Projection("EPSG:4269");
GdD.MERCATOR = new OpenLayers.Projection('EPSG:900913');
OpenLayers.ProxyHost = "/proxy?url=";
GdD.Map.prototype = {
    options : {
        centerx: 0, centery: 0, zoom: 2, mapdiv: 'map'
    },
    map: null,
    init : function(options) {
        self = this;
        self.options = $.extend(self.options, options);
        self.map = new OpenLayers.Map({
            div: self.options.mapdiv,

            displayProjection: GdD.GEOGRAPHIC,
            projection: GdD.MERCATOR,
            queryProtocol : new OpenLayers.Protocol.WFS({
                version: "1.1.0",
                url:  "http://www1.4net2.net:8080/geoserver/wfs?",
                featureType: "hydrogl020",
                featureNS: "http://www.geodatadesign.com/giserv",
                srsName: "EPSG:900913"
            }),
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
                new OpenLayers.Layer.WMS("Geoserver", "http://www1.4net2.net:8080/geoserver/wms",
                    { layers: "giserv:trips", transparent: true },
                    {
                        isBaseLayer: false,
                        projection: GdD.GEOGRAPHIC,
                        maxExtent: new OpenLayers.Bounds(-100,20, -50,50),
                        opacity: 0.5
                    }
                ),
            //  new OpenLayers.Layer.WMS( "OpenLayers WMS", "http://vmap0.tiles.osgeo.org/wms/vmap0?",
            //      {layers: 'basic'} ),
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
                new OpenLayers.Control.LayerSwitcher()
            ],
        //  projection: new OpenLayers.Projection("EPSG:4269"),
        //  displayProjection: new OpenLayers.Projection('EPSG:900913'),
            center: new OpenLayers.LonLat(self.options.centerx, self.options.centery),
            zoom: self.options.zoom
        });
    }
};
