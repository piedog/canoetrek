var GdD = {};
GdD.Test = function() {};
Proj4js.defs['EPSG:4269'] = '+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs';

GdD.Test.prototype = {
    map : new OpenLayers.Map({
        div: "map-container",
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
            )
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
        //  new OpenLayers.Control.Click({'name':'clickcontrol'}),
            new OpenLayers.Control.LayerSwitcher()
        ],

    //  center: [-10545985, 4323684],
        zoom: 9,
        projection: new OpenLayers.Projection("EPSG:4269"),
        displayProjection: new OpenLayers.Projection('EPSG:900913')
    })
}
