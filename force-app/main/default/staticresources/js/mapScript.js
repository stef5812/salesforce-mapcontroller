//copyright © 2024 Stefan Dodds @ stefandodds.ie, All rights reserved

// Initialize the map variable and marker arrays
var map;
var opsMarkers = [];
var optbmMarkers = [];
var optbreMarkers = [];
var volaMarkers = [];
var volftacMarkers = [];
var voltbmMarkers = [];
var opsMarkersVisible = false;
var optbmMarkersVisible = false;
var optbreMarkersVisible = false;
var volaMarkersVisible = false;
var volftacMarkersVisible = false;
var voltbmMarkersVisible = false;

// Separate array to track open InfoWindows for OPs, OPTBM, and OPTBRE
var openOpsInfoWindows = [];
var openOptbmInfoWindows = [];
var openOptbreInfoWindows = [];
var openvolaInfoWindows = [];
var openvolftacInfoWindows = [];
var openvoltbmInfoWindows = [];

var currentChn = null;

// Function to add markers
function addMarker(location, iconUrl, markerType) {
    if (!location.LatLon__Latitude__s || !location.LatLon__Longitude__s) {
        console.warn("Invalid location data (missing latitude/longitude): ", location);
        return null; // Skip adding marker if location data is invalid
    }

    var latLng = new google.maps.LatLng(location.LatLon__Latitude__s, location.LatLon__Longitude__s);

    // Create the marker
    var marker = new google.maps.Marker({
        position: latLng,
        map: map,
        title: location.Name__c,  // Default title can still be Name
        icon: {
            url: iconUrl,  // Custom icon
            scaledSize: new google.maps.Size(60, 90)
        }
    });

    // Info window for hover
    var hoverInfoWindowContent = '<div><strong>' + location.First_Name__c + ' ' + location.Surname__c + '</strong></div>';
    var hoverInfoWindow = new google.maps.InfoWindow({
        content: hoverInfoWindowContent
    });

    // Construct dynamic URL based on the marker type
    var recordUrl = '';
    if (markerType === 'ops') {
        recordUrl = `https://brave-badger-fohzlw-dev-ed.trailblaze.lightning.force.com/lightning/r/OPs__c/${location.Id}/view`;
    } else if (markerType === 'vola' || markerType === 'volftac' || markerType === 'voltbm') {
        recordUrl = `https://brave-badger-fohzlw-dev-ed.trailblaze.lightning.force.com/lightning/r/Volunteers__c/${location.Id}/view`;
    } else {
        recordUrl = `https://brave-badger-fohzlw-dev-ed.trailblaze.lightning.force.com/lightning/r/${markerType}/${location.Id}/view`; // Default fallback
    }    

    // Info window for click
    var clickInfoWindowContent = `
        <div class="infowindow ${markerType}">
            <h4>${location.First_Name__c} ${location.Surname__c}</h4>
            <p>Sex: ${location.Sex__c ? location.Sex__c : 'N/A'}</p>
            <p>Pets: ${location.Pets__c ? 'Yes' : 'No'}</p>
            <p>Smoker: ${location.Smoker__c || location.Smoking__c ? 'Yes' : 'No'}</p>
            <p>Age: ${location.Age__c ? location.Age__c : 'N/A'}</p>
            <a href="${recordUrl}" target="_blank">View Full Record</a>
        </div>
    `;

    var clickInfoWindow = new google.maps.InfoWindow({
        content: clickInfoWindowContent
    });

    // Create the radius circles (hidden by default)
    var circle20km = new google.maps.Circle({
        strokeColor: '#FF0000',
        strokeOpacity: 0.9,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0,
        map: null,  // Initially hidden
        center: latLng,
        radius: 10000
    });

    var circle30km = new google.maps.Circle({
        strokeColor: '#FF0000',
        strokeOpacity: 0.95,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0,
        map: null,  // Initially hidden
        center: latLng,
        radius: 20000
    });    

    // Store the click info window on the marker for reference later
    marker.clickInfoWindow = clickInfoWindow;

    // Add event listeners for hover and click
    marker.addListener('mouseover', function () {
        if (!clickInfoWindow.getMap()) {  // Only show hover info if click window isn't open
            hoverInfoWindow.open(map, marker);
        }
        // Show the radius circles on mouseover
        circle20km.setMap(map);
        circle30km.setMap(map);        
    });

    marker.addListener('mouseout', function () {
        if (!clickInfoWindow.getMap()) {  // Only close hover info if click window isn't open
            hoverInfoWindow.close();
        }
        // Show the radius circles on mouseover
        circle20km.setMap(null);
        circle30km.setMap(null);   
    });

    marker.addListener('click', function () {
        hoverInfoWindow.close();  // Close hover window when clicking
        clickInfoWindow.open(map, marker);  // Open the additional info window on click

        // Add to the correct list based on marker type
        if (markerType === 'ops') {
            openOpsInfoWindows.push(clickInfoWindow);
        } else if (markerType === 'optbm') {
            openOptbmInfoWindows.push(clickInfoWindow);
        } else if (markerType === 'optbre') {
            openOptbreInfoWindows.push(clickInfoWindow);
        } else if (markerType === 'vola') {
            openvolaInfoWindows.push(clickInfoWindow);  // Track VOLA info windows
        } else if (markerType === 'volftac') {
            openvolftacInfoWindows.push(clickInfoWindow);  // Track VOLFtAc info windows
        } else if (markerType === 'voltbm') {
            openvoltbmInfoWindows.push(clickInfoWindow);  // Track VOLTBM info windows
        }
    });

    return marker;
}

function toggleMarkers(type, visibility) {
    console.log("Toggling markers for: " + type);

    if (visibility === "chn") {
        console.log("Change chn Hide markers" + type)
        if (type === "ops") {
            opsMarkersVisible = true;
        } else if (type === "optbm") {
            optbmMarkersVisible = true;
        } else if (type === "optbre") {
            optbreMarkersVisible = true;
        }
        visibility = "";
    }

    if (type === 'ops') {
        opsMarkersVisible = !opsMarkersVisible;

        console.log("Setting OPs markers visibility to: " + opsMarkersVisible);
        opsMarkers.forEach(function(marker) {
            marker.setVisible(opsMarkersVisible);
        });

        // If hiding OPs markers, close all open OPs info windows
        if (!opsMarkersVisible) {
            openOpsInfoWindows.forEach(function(infoWindow) {
                infoWindow.close();
            });
            openOpsInfoWindows = [];  // Clear the list of open windows
        }
    } else if (type === 'optbm') {
        optbmMarkersVisible = !optbmMarkersVisible;
        console.log("Setting OPTBM markers visibility to: " + optbmMarkersVisible);
        optbmMarkers.forEach(function(marker) {
            marker.setVisible(optbmMarkersVisible);
        });

        // If hiding OPTBM markers, close all open OPTBM info windows
        if (!optbmMarkersVisible) {
            openOptbmInfoWindows.forEach(function(infoWindow) {
                infoWindow.close();
            });
            openOptbmInfoWindows = [];  // Clear the list of open windows
        }
    } else if (type === 'optbre') {
        optbreMarkersVisible = !optbreMarkersVisible;
        console.log("Setting OPTBRE markers visibility to: " + optbreMarkersVisible);
        optbreMarkers.forEach(function(marker) {
            marker.setVisible(optbreMarkersVisible);
        });

        // If hiding OPTBRE markers, close all open OPTBRE info windows
        if (!optbreMarkersVisible) {
            openOptbreInfoWindows.forEach(function(infoWindow) {
                infoWindow.close();
            });
            openOptbreInfoWindows = [];  // Clear the list of open windows
        }
    } else if (type === 'vola') {
        volaMarkersVisible = !volaMarkersVisible;
        console.log("Setting VOLA markers visibility to: " + volaMarkersVisible);
        volaMarkers.forEach(function(marker) {
            marker.setVisible(volaMarkersVisible);
        });

        // If hiding OPTBRE markers, close all open OPTBRE info windows
        if (!volaMarkersVisible) {
            openvolaInfoWindows.forEach(function(infoWindow) {
                infoWindow.close();
            });
            openvolaInfoWindows = [];  // Clear the list of open windows
        }        
    } else if (type === 'volftac') {
        volftacMarkersVisible = !volftacMarkersVisible;
        console.log("Setting VOLFtAc markers visibility to: " + volftacMarkersVisible);
        volftacMarkers.forEach(function(marker) {
            marker.setVisible(volftacMarkersVisible);
        });

        // If hiding OPTBRE markers, close all open OPTBRE info windows
        if (!volftacMarkersVisible) {
            openvolftacInfoWindows.forEach(function(infoWindow) {
                infoWindow.close();
            });
            openvolftacInfoWindows = [];  // Clear the list of open windows
        }        
    } else if (type === 'voltbm') {
        voltbmMarkersVisible = !voltbmMarkersVisible;
        console.log("Setting VOLTBM markers visibility to: " + voltbmMarkersVisible);
        voltbmMarkers.forEach(function(marker) {
            marker.setVisible(voltbmMarkersVisible);
        });

        // If hiding OPTBRE markers, close all open OPTBRE info windows
        if (!voltbmMarkersVisible) {
            openvoltbmInfoWindows.forEach(function(infoWindow) {
                infoWindow.close();
            });
            openvoltbmInfoWindows = [];  // Clear the list of open windows
        }        
    }
}