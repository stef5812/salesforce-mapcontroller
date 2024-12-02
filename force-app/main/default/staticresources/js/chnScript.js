//copyright © 2024 Stefan Dodds @ stefandodds.ie, All rights reserved


var chnPolygons = {};
var infoWindow = new google.maps.InfoWindow(); 

var chnCoordinates = {
    'chn1': [
        { lat: 51.9, lng: -8.4 },
        { lat: 51.8, lng: -8.6 },
        { lat: 51.7, lng: -8.5 },
        { lat: 51.8, lng: -8.3 }
    ],
    'chn2': [
        { lat: 52.0, lng: -8.5 },
        { lat: 51.95, lng: -8.7 },
        { lat: 51.9, lng: -8.4 }
    ],
    'chn3': [
        { lat: 52.2, lng: -8.3 },
        { lat: 52.1, lng: -8.5 },
        { lat: 52.0, lng: -8.4 }
    ],
    'chn4': [
        { lat: 52.3, lng: -8.1 },
        { lat: 52.2, lng: -8.4 },
        { lat: 52.1, lng: -8.2 }
    ]
};

// Create polygons for each CHN
function initPolygons() {
    for (var chn in chnCoordinates) {
        if (chnCoordinates.hasOwnProperty(chn)) {
            chnPolygons[chn] = createPolygon(chnCoordinates[chn], getRandomColor());
        }
    }

    // Ensure the polygons are initially hidden
    for (var chn in chnPolygons) {
        chnPolygons[chn].setMap(null);
    }

    console.log('CHN Polygons created:', chnPolygons);
}

// Helper function to create a polygon
function createPolygon(coordinates, color) {
    return new google.maps.Polygon({
        paths: coordinates,
        strokeColor: color,
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: color,
        fillOpacity: 0.35,
        map: null // Initially hidden
    });
}

// Helper function to get a random color
function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}


//Init map other function
function initMap2(){ 

                // Sample CHN Coordinates (Replace with actual data)
                var chnCoordinates = {
                    'chn1': [
                        {lat: 51.9, lng: -8.4},
                        {lat: 51.8, lng: -8.6},
                        {lat: 51.7, lng: -8.5},
                        {lat: 51.8, lng: -8.3}
                    ],
                    'chn2': [
                        {lat: 52.0, lng: -8.5},
                        {lat: 51.95, lng: -8.7},
                        {lat: 51.9, lng: -8.4}
                    ],
                    'chn3': [
                        {lat: 52.2, lng: -8.3},
                        {lat: 52.1, lng: -8.5},
                        {lat: 52.0, lng: -8.4}
                    ],
                    'chn4': [
                        {lat: 52.3, lng: -8.1},
                        {lat: 52.2, lng: -8.4},
                        {lat: 52.1, lng: -8.2}
                    ]                
                    
                };  
                
                // Create polygons for each CHN
                for (var chn in chnCoordinates) {
                    if (chnCoordinates.hasOwnProperty(chn)) {
                        chnPolygons[chn] = createPolygon(chnCoordinates[chn], getRandomColor());
                    }
                }
            
                // Ensure the polygons are initially hidden
                for (var chn in chnPolygons) {
                    chnPolygons[chn].setMap(null);
                }   
                
                // Initialize each CHN polygon
                for (var chn in chnCoordinates) {
                    chnPolygons[chn] = createPolygon(chnCoordinates[chn], getRandomColor());
                }                                
                
                console.log("CHN Coordinates: ", chnCoordinates);
               
                
                console.log('CHN Polygons created:', chnPolygons);       
                                 
}  

